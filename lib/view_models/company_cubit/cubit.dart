import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentx/models/company_info_model.dart';
import 'package:rentx/models/rental_model.dart';
import 'package:rentx/services/company_service.dart';
import 'package:rentx/view_models/car_fleet_cubit/cubit.dart';
import 'package:rentx/view_models/company_cubit/states.dart';

class CompanyCubit extends Cubit<CompanyStates> {
  CompanyCubit() : super(CompanyStates());
  List<RentalResult> companyRentals = [];

  static CompanyCubit get(context) => BlocProvider.of(context);

  final CompanyService _companyService = CompanyService();

  CompanyInfoModel? companyInfoModel;

  getLoggedUserCompany() {
    emit(GetCompanyInfoLoadingState());
    _companyService
        .getLoggedUserCompany()
        .then((value) {
          companyInfoModel = value;
          emit(GetCompanyInfoSuccessState());
        })
        .then((value) => _getCompanyRentals(companyInfoModel!.id!))
        .catchError((error) {
          emit(GetCompanyInfoErrorState());
        })
        .then((value) {
          CarFleetCubit().carFleets = companyRentals;
        });
  }

  getCompanyInfo(final String id) {
    emit(GetCompanyInfoLoadingState());
    _companyService
        .getCompanyInfo(id)
        .then((value) {
          companyInfoModel = value;
        })
        .then((value) => _getCompanyRentals(id))
        .catchError((error) {
          emit(GetCompanyInfoErrorState());
        })
        .then((value) {
          CarFleetCubit().carFleets = companyRentals;
        });
  }

  _getCompanyRentals(String id) {
    _companyService.getCarFleet(id).then((value) {
      companyRentals = value.result!;
      emit(GetCompanyInfoSuccessState());
    }).catchError((err) {
      emit(GetCompanyInfoErrorState());
    });
  }
}
