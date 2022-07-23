import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentx/models/rental_details_model.dart';
import 'package:rentx/models/rental_model.dart';
import 'package:rentx/services/company_service.dart';
import 'package:rentx/services/rental_service.dart';
import 'package:rentx/ui/widgets/map/rentx_map_card.dart';
import 'package:rentx/view_models/car_fleet_cubit/states.dart';
import 'package:table_calendar/table_calendar.dart';

class CarFleetCubit extends Cubit<CarFleetStates> {
  CarFleetCubit() : super(CarFleetStates());

  static CarFleetCubit get(context) => BlocProvider.of(context);

  final RentalService _rentalService = RentalService();
  final CompanyService _companyService = CompanyService();
  int managercarousalIndex = 0;
  RentalDetailsResult? rentalDetailsResult;
  List<RentalResult> carFleets = [];
  final RentXMapController mapController = RentXMapController();

  DateTime currentDate = DateTime(2022, 6, 10);
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
      OnChangeManagerState(),
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
        OnChangeManagerState(),
      );
    }
  }

  toggleFormat(value) {
    calendarFormat = value;
    emit(
      OnChangeManagerState(),
    );
  }

  toggleFocusedDay(value) {
    focusedDay = focusedDay;
    emit(
      OnChangeManagerState(),
    );
  }

  changeIndex(int value) {
    managercarousalIndex = value;
    emit(OnChangeManagerState());
  }

  getCarFleet({String? companyId}) {
    emit(GetCarFleetLoadingStae());
    if (companyId == null) {
      _companyService.getLoggedUserCompany().then((value) {
        _getCarFleetForCompany(value.id!);
      });
    } else {
      _getCarFleetForCompany(companyId);
    }
  }

  setCarFleet(List<RentalResult> carFleet) {
    carFleets = carFleet;
    emit(GetCarFleetSuccessState());
  }

  _getCarFleetForCompany(String companyId) {
    _companyService.getCarFleet(companyId).then((value) {
      carFleets = value.result!;
      emit(GetCarFleetSuccessState());
    }).catchError((error) {
      emit(GetCarFleetErrorState());
    });
  }

  getCarFleetDetails(String id) {
    emit(GetCarFleetLoadingStae());
    _rentalService.getRentalDetails(id).then((value) {
      rentalDetailsResult = value.result;
      emit(GetCarFleetSuccessState());
    }).catchError((error) {
      emit(GetCarFleetErrorState());
    });
  }
}
