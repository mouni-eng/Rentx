import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentx/models/car.dart';
import 'package:rentx/models/car_mdels.dart';
import 'package:rentx/models/rental_filter_model.dart';
import 'package:rentx/models/rental_model.dart';
import 'package:rentx/services/car_service.dart';
import 'package:rentx/services/property_service.dart';
import 'package:rentx/view_models/filter_cubit/states.dart';

class FilterCubit extends Cubit<FilterStates> {
  FilterCubit() : super(FilterStates());

  static FilterCubit get(context) => BlocProvider.of(context);
  final PropertyService _propertyService = PropertyService();
  final CarService _carService = CarService();
  RentalFilterModel filterModel = RentalFilterModel();

  List<TopBrandsResult>? carBrands;
  List<String>? transmissionValues;
  List<CarType>? carTypeValues = CarType.values;
  List<String>? seatValues;

  TopBrandsResult? brandChosen;
  CarType? carTypeChosen;
  String? transmissionChosen;
  String? seatChosen;

  bool _initialized = false;

  RangeValues rangeValues = const RangeValues(10, 1000);

  initialize() {
    emit(FilterLoadingState());
    if (!_initialized) {
      _propertyService
          .getCarProperty(CarPropertyType.transmission)
          .then((value) {
            transmissionValues = value.values;
          })
          .then((value) => _getSeatValues())
          .then((value) => _getCarBrands())
          .then((value) {
            _initialized = true;
            emit(FilterReadyState());
          });
    } else {
      emit(FilterReadyState());
    }
  }

  chooseBrand(TopBrandsResult brand) {
    brandChosen = brand;
    emit(OnChooseValueState());
  }

  chooseCarType(CarType type) {
    carTypeChosen = type;
    emit(OnChooseValueState());
  }

  chooseTransmission(String transmission) {
    transmissionChosen = transmission;
    emit(OnChooseValueState());
  }

  chooseCarPrice(RangeValues values) {
    rangeValues = values;
    emit(OnChooseValueState());
  }

  chooseSeat(String seat) {
    seatChosen = seat;
    emit(OnChooseValueState());
  }

  resetFilter() {
    brandChosen = null;
    carTypeChosen = null;
    transmissionChosen = null;
    rangeValues = const RangeValues(10, 1000);
    emit(OnChooseValueState());
  }

  Future<void> _getCarBrands() async {
    await _carService.getTopBrands().then((value) => carBrands = value.result);
  }

  Future<void> _getSeatValues() async {
    await _propertyService
        .getCarProperty(CarPropertyType.seats)
        .then((value) => seatValues = value.values!);
  }

  void saveFilter() {
    filterModel = RentalFilterModel(
        properties: {
          CarPropertyType.transmission: transmissionChosen,
          CarPropertyType.seats: seatChosen
        },
        carType: carTypeChosen,
        minPrice: rangeValues.start,
        maxPrice: rangeValues.end,
        rentalStatus: RentalStatus.available,
        paginationModel: PaginationModel(pageNumber: 0, pageSize: 1000));
    emit(FilterSavedState());
  }
}
