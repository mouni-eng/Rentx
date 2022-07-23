import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rentx/models/car.dart';
import 'package:rentx/models/car_mdels.dart';
import 'package:rentx/models/file_upload.dart';
import 'package:rentx/models/image.dart';
import 'package:rentx/models/input_properties.dart';
import 'package:rentx/models/rental_model.dart';
import 'package:rentx/services/car_service.dart';
import 'package:rentx/services/file_service.dart';
import 'package:rentx/services/property_service.dart';
import 'package:rentx/services/rental_service.dart';
import 'package:rentx/ui/screens/car_listing_screens/create/steps/liscience_plate_screen.dart';
import 'package:rentx/ui/screens/car_listing_screens/create/steps/make_model_screen.dart';
import 'package:rentx/ui/screens/car_listing_screens/create/steps/set_properties.dart';
import 'package:rentx/ui/screens/car_listing_screens/create/steps/upload_images_screen.dart';
import 'package:rentx/view_models/car_listing_cubit/states.dart';

class CarListingCubit extends Cubit<CarListingStates> {
  CarListingCubit() : super(CarListingStates());

  static CarListingCubit get(context) => BlocProvider.of(context);

  List<CarBrand> carBrands = [];
  List<CarBrandModel> carBrandModels = [];
  String? liscencePlate;
  CarBrand? carChoosen;
  CarBrandModel? carBrandModelChoosen;
  Map<CarPropertyType, dynamic> properties = {};
  List<File> images = [];
  int featured = 0;
  bool isLast = false;
  int index = 0;
  double percent = 0.25;
  PageController controller = PageController();
  final formKey = GlobalKey<FormState>();
  RangeValues rangeValues = const RangeValues(10, 1000);

  List<CarPropertyInput>? carPropertyInputs;

  final CarService _carService = CarService();
  final PropertyService _propertyService = PropertyService();
  final RentalService _rentalService = RentalService();
  final FileService _fileService = FileService();

  List<String> headers = [
    "Let’s Select Make & Model",
    "Set Properties",
    "Upload Photos",
    "Set Lience Plate & Price",
  ];

  List<Widget> steps = [
    const MakeModelWidget(),
    const SetPropertiesWidget(),
    const UploadPhotosWidget(),
    const LisencePlateWidget(),
  ];

  getCarsData() {
    _carService.getBrands().then((value) {
      carBrands = value;
      emit(CarBrandsLoadedState());
    });
  }

  getProperties() {
    emit(CarPropertiesLoadingState());
    _propertyService.getCarProperties().then((value) {
      carPropertyInputs = value;
      emit(CarPropertiesLoadedState());
    });
  }

  onBackStep() {
    if (percent != 0.25) {
      percent -= 0.25;
      index -= 1;
      isLast = false;
      emit(OnBackStepState());
    }

    controller.previousPage(
        duration: const Duration(
          milliseconds: 750,
        ),
        curve: Curves.fastLinearToSlowEaseIn);
  }

  onNextStep() {
    if (percent != 1) {
      percent += 0.25;
      index += 1;
      if (index == 3) {
        isLast = true;
      }
      getProperties();
      emit(OnNextStepState());
    }
    controller.nextPage(
        duration: const Duration(
          milliseconds: 750,
        ),
        curve: Curves.fastLinearToSlowEaseIn);
  }

  validateNext(context) {
    if (index == 0) {
      if (carChoosen != null && carBrandModelChoosen != null) {
        onNextStep();
      }
    } else if (index == 1) {
      if (formKey.currentState!.validate()) {
        onNextStep();
      }
    } else if (index == 2) {
      if (images.isNotEmpty) {
        onNextStep();
      }
    } else {
      if (liscencePlate != null) {
        _createRental();
      }
    }
  }

  chooseCarMake(String makeId) {
    carChoosen = carBrands.firstWhere((element) => element.id == makeId);
    _carService.getModels(carChoosen!.make!).then((value) {
      carBrandModels = value;
      emit(ChooseCarCompanyState());
    });
  }

  chooseCarModel(String brandId) {
    carBrandModelChoosen =
        carBrandModels.firstWhere((element) => element.id == brandId);
    emit(ChooseCarModelState());
  }

  addCarProperties(CarPropertyType property, dynamic value) {
    properties.update(property, (v) => value, ifAbsent: () => value);
    emit(AddCarPropertyState());
  }

  var picker = ImagePicker();

  chooseImage(File file) async {
    images.add(file);
    emit(ChooseCarImagesState());
  }

  updateImageFeatured(int index) {
    featured = index;
    emit(UpdateCarImagesState());
  }

  chooseCarPrice(RangeValues values) {
    rangeValues = values;
    emit(ChooseCarPriceState());
  }

  chooseCarLicsense(String value) {
    liscencePlate = value;
    emit(ChooseCarPlateState());
  }

  void _createRental() {
    emit(RentalCreationInProgress());
    _uploadImages().then((uploadedImages) {
      _rentalService
          .createRental(CreateRentalRequest(
            carModelCarTypeId: carBrandModelChoosen!.carModelCarTypeId,
            licensePlate: liscencePlate,
            price: rangeValues.start,
            status: RentalStatus.available.value(),
            images: uploadedImages,
            properties: properties.entries
                .map((e) => CarListingProperty(type: e.key, value: e.value))
                .toList(),
          ))
          .then((value) => emit(RentalCreatedState()));
    });
  }

  Future<List<UploadFeaturedImage>> _uploadImages() async {
    var res = await _fileService.upload('/fileUpload',
        FileUploadRequest(files: images, uploadType: FileUploadType.rental));
    return res.fileIds!
        .map((e) => UploadFeaturedImage(
            id: e, isFeatured: res.fileIds!.indexOf(e) == featured))
        .toList();
  }
}
