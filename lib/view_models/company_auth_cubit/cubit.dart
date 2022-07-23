import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentx/extensions/list_extension.dart';
import 'package:rentx/infrastructure/exceptions.dart';
import 'package:rentx/infrastructure/utils.dart';
import 'package:rentx/models/address.dart';
import 'package:rentx/models/file_upload.dart';
import 'package:rentx/models/location.dart';
import 'package:rentx/models/user.dart';
import 'package:rentx/services/auth_service.dart';
import 'package:rentx/services/file_service.dart';
import 'package:rentx/services/map/map_service.dart';
import 'package:rentx/ui/screens/auth_screens/company_registration_screens/address_selection.dart';
import 'package:rentx/ui/screens/auth_screens/company_registration_screens/company_data.dart';
import 'package:rentx/ui/widgets/map/rentx_map_card.dart';
import 'package:rentx/view_models/company_auth_cubit/states.dart';

class CompanyAuthCubit extends Cubit<CompanyAuthStates> {
  CompanyAuthCubit() : super(CompanyAuthStates());

  static CompanyAuthCubit get(context) => BlocProvider.of(context);

  CompanySignUpRequest companySignUpRequest = CompanySignUpRequest.instance();
  final AuthService _authService = AuthService();
  final FileService _fileService = FileService();
  final RentXMapController mapController = RentXMapController();
  final formKey4 = GlobalKey<FormState>();
  late MapService _mapService;
  PageController companyController = PageController();
  int companyIndex = 0;
  bool companyIsLast = false;
  double companyPercent = 1 / 2;
  String? companyName, companyEmail, companyDescription, companyPhone, notes;
  File? logoImage;
  File? headerImage;
  String? bannerFileId, logoFileId;
  Address? address;
  RentXLocation location = RentXLocation(
      city: 'Tirana',
      state: 'AL',
      street: 'Blv. Bajram Curri',
      zip: '1001',
      longitude: 19.8216,
      latitude: 41.3232);

  List<String> companyHeaders = [
    "Company Data",
    "Address Selection",
  ];

  List<Widget> companySteps = [
    const CompanyData(),
    const AddressSelection(),
  ];

  onNextStepCompany() {
    if (companyPercent != 1) {
      companyPercent += 1 / 2;
      companyIndex += 1;
      if (companyIndex == 1) {
        companyIsLast = true;
      }
      emit(OnNextRegistrationStep());
    }
    companyController.nextPage(
        duration: const Duration(
          milliseconds: 750,
        ),
        curve: Curves.fastLinearToSlowEaseIn);
  }

  chooseLogoImage(File file) async {
    logoImage = file;
    emit(ChooseProfileImageState());
  }

  chooseBannerImage(File file) async {
    headerImage = file;
    emit(ChooseProfileImageState());
  }

  onChangeCompanyName(String value) {
    companyName = value;
    emit(OnChangeState());
  }

  onChangeCompanyDescription(String value) {
    companyDescription = value;
    emit(OnChangeState());
  }

  onChangeCompanyEmail(String value) {
    companyEmail = value;
    emit(OnChangeState());
  }

  onChangeCompanyPhone(String value) {
    companyPhone = value;
    emit(OnChangeState());
  }

  onChangeCompanyNotes(String value) {
    notes = value;
    emit(OnChangeState());
  }

  uploadLogoPicture() async {
    if (logoImage != null && logoFileId == null) {
      await _fileService
          .upload(
        'fileUpload',
        FileUploadRequest(
            files: [logoImage!], uploadType: FileUploadType.profileImage),
      )
          .then((value) {
        if (value.fileIds != null) {
          logoFileId = value.fileIds![0];
          emit(OnChangeState());
        }
      });
    }
  }

  uploadHeaderPicture() async {
    if (headerImage != null && bannerFileId == null) {
      await _fileService
          .upload(
              'fileUpload',
              FileUploadRequest(
                  files: [headerImage!], uploadType: FileUploadType.company))
          .then((value) {
        if (value.fileIds != null) {
          bannerFileId = value.fileIds![0];
          emit(OnChangeState());
        }
      });
    }
  }

  saveCompany() async {
    emit(CompanyRegisterLoadingState());
    await uploadLogoPicture();
    await uploadHeaderPicture();
    _authService
        .companyRegister(CompanySignUpRequest(
      name: companyName,
      email: companyEmail,
      phone: companyPhone,
      description: companyDescription,
      isFeatured: true,
      featuredPriority: "0",
      address: address,
      logoFileId: logoFileId,
      bannerFileId: bannerFileId,
    ))
        .then((value) {
      emit(CompanyRegisterSuccessState());
    }).catchError((error) {
      ApiException exception = error;
      emit(CompanyRegisterErrorState(error: exception.errorMessage.toString()));
    });
  }

  Future<List<RentXLocation>> searchLocation(final String address) async {
    return (await _mapService.query(address))
        .where((element) => element.city.isNotEmpty)
        .toList()
        .unique((element) => element.fullAddress());
  }

  void fetchData() async {
    _mapService = await MapServiceFactory().getMapService();
  }

  updateLocation(RentXLocation loc) {
    _setLocation(loc);
    location = loc;
    mapController.move!.call(loc);
  }

  getCurrentLocation() {
    determinePosition().then((loc) {
      setPosition(RentXLatLong(loc.latitude, loc.longitude));
    }).catchError((err) {
      emit(CompanyRegisterErrorState(error: err));
    });
  }

  _setLocation(RentXLocation value) {
    address = Address(
        latitude: value.latitude,
        longitude: value.longitude,
        zip: ZipUtil.parseZip(value.zip),
        street: value.street,
        city: City(country: value.state, countryCode: 'AL', name: value.city),
        notes: address?.notes);
    emit(OnChangeState());
  }

  setPosition(RentXLatLong pos) {
    _mapService.exactLocation(pos).then((value) {
      _setLocation(value);
    });
  }

  bool isVisible = false;

    searchOnChange() {
    isVisible = !isVisible;
    emit(OnChangeState());
  }

  searchOnTap() {
    isVisible = true;
    emit(OnChangeState());
  }

}
