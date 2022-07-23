import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentx/extensions/list_extension.dart';
import 'package:rentx/models/location.dart';
import 'package:rentx/models/rental_filter_model.dart';
import 'package:rentx/models/rental_model.dart';
import 'package:rentx/services/map/map_service.dart';
import 'package:rentx/services/rental_service.dart';
import 'package:rentx/ui/widgets/map/rentx_map_card.dart';
import 'package:rentx/view_models/search_cubit/states.dart';
import 'package:table_calendar/table_calendar.dart';

class SearchCubit extends Cubit<SearchStates> {
  SearchCubit() : super(SearchStates());

  static SearchCubit get(context) => BlocProvider.of(context);
  final RentalService _rentalService = RentalService();
  late MapService _mapService;
  final RentXMapController mapController = RentXMapController();

  List<RentalResult> mapRentals = [];
  RentalResult? model;

  RentXLocation location = RentXLocation(
      city: 'Tirana',
      state: 'AL',
      street: 'Blv. Bajram Curri',
      zip: '1001',
      longitude: 19.8216,
      latitude: 41.3232);

  Future<List<RentXLocation>> searchLocation(final String address) async {
    return (await _mapService.query(address))
        .where((element) => element.city.isNotEmpty)
        .toList()
        .unique((element) => element.fullAddress());
  }

  void init() async {
    _mapService = await MapServiceFactory().getMapService();
  }

  setRentals(List<RentalResult> rentals) {
    mapRentals = rentals;
  }

  updateLocation(RentXLocation loc) {
    location = loc;
    mapController.move!.call(loc);
    emit(OnChangeLocationState());
  }

  searchFiltered(RentalFilterModel filterModel) {
    emit(SearchLoadingState());
    _rentalService.getFilteredRentals(filterModel).then((value) {
      mapRentals = value.result!;
      emit(GetMapRentalsSuccessState());
    });
  }

  getMapRentals() {
    mapRentals = [];
    emit(GetMapRentalsLoadingState());
    _rentalService
        .getFilteredRentals(RentalFilterModel(
      latitude: 41.3232,
      longitude: 19.8216,
      radius: 1000000,
      paginationModel: PaginationModel(
        pageNumber: 0,
        pageSize: 150,
      ),
      sort: Sort(
        sortBy: "Date",
        sortOrder: "DESC",
      ),
    ))
        .then((value) {
      mapRentals.addAll(value.result!);
      emit(GetMapRentalsSuccessState());
    }).catchError((error) {
      print(error);
      emit(GetMapRentalsErrorState());
    });
  }

  getCurrentRental(RentalResult rentalResult) {
    model = rentalResult;
    emit(GetMapRentalsSuccessState());
  }

  void currentLocation() {
    determinePosition().then((pos) {
      _mapService
          .exactLocation(RentXLatLong(pos.latitude, pos.longitude))
          .then((location) {
        updateLocation(location);
      });
    }).catchError((err) {
      emit(GpsErrorState(err is String ? err : err.errorCode));
    });
  }

  // handling calander filter section in Search Screen

  bool isCalanderVisible = false;
  bool isSearchVisible = false;

  DateTime currentDate = DateTime.now();
  CalendarFormat calendarFormat = CalendarFormat.month;
  RangeSelectionMode rangeSelectionMode = RangeSelectionMode
      .toggledOn; // Can be toggled on/off by longpressing a date
  DateTime? selectedDay;
  DateTime focusedDay = DateTime.now();
  DateTime? rangeStart;
  DateTime? rangeEnd;

  chooseDateEnd(DateTime? start, DateTime? end, DateTime? focusDay) {
    selectedDay = null;
    focusedDay = focusDay!;
    rangeEnd = end;
    rangeStart = start;
    rangeSelectionMode = RangeSelectionMode.toggledOn;
    emit(
      OnChangeCalanderState(),
    );
  }

  chooseDate(DateTime value, value2) {
    if (!isSameDay(value, selectedDay)) {
      selectedDay = value;
      focusedDay = value2;
      rangeStart = null; // Important to clean those
      rangeEnd = null;
      rangeSelectionMode = RangeSelectionMode.toggledOff;
      emit(
        OnChangeCalanderState(),
      );
    }
  }

  toggleFormat(value) {
    calendarFormat = value;
    emit(
      OnChangeCalanderState(),
    );
  }

  toggleFocusedDay(value) {
    focusedDay = focusedDay;
    emit(
      OnChangeCalanderState(),
    );
  }

  toogleVisiblity() {
    isCalanderVisible = !isCalanderVisible;
    emit(OnChangeCalanderState());
  }

  searchOnChange() {
    isSearchVisible = !isSearchVisible;
    emit(OnChangeCalanderState());
  }

  searchOnTap() {
    isSearchVisible = true;
    emit(OnChangeCalanderState());
  }

  applyCalanderFilter() {
    toogleVisiblity();
    mapRentals = [];
    emit(GetMapRentalsLoadingState());
    _rentalService
        .getFilteredRentals(RentalFilterModel(
      latitude: 41.3232,
      longitude: 19.8216,
      radius: 1000000,
      paginationModel: PaginationModel(
        pageNumber: 0,
        pageSize: 150,
      ),
      sort: Sort(
        sortBy: "Date",
        sortOrder: "DESC",
      ),
      fromDate: rangeStart,
      toDate: rangeEnd,
    ))
        .then((value) {
      mapRentals.addAll(value.result!);
      emit(GetMapRentalsSuccessState());
    }).catchError((error) {
      print(error);
      emit(GetMapRentalsErrorState());
    });
  }
}
