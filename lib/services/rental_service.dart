import 'package:rentx/models/company_info_model.dart';
import 'package:rentx/models/rental_details_model.dart';
import 'package:rentx/models/rental_filter_model.dart';
import 'package:rentx/models/rental_model.dart';
import 'package:rentx/services/company_service.dart';
import 'package:rentx/services/rentx_service.dart';

class RentalService extends RentXService {
  final CompanyService _companyService = CompanyService();

  Future<RentalModel> getFilteredRentals(
      RentalFilterModel rentalFilterModel) async {
    var resp = await httpService.doPost(
        url: "/rental/filter/", rentXRequest: rentalFilterModel);
    return RentalModel.fromJson(resp);
  }

  Future<RentalModel> getBestDeals() async {
    var resp = await httpService.doGet("/rental/bestDeals/");
    return RentalModel.fromJson(resp);
  }

  Future<List<CompanyInfoModel>> getFeaturedDealers() async {
    var resp =
        (await httpService.doGet("/company/featured/"))['result'] as List;
    return resp.map((e) => CompanyInfoModel.fromJson(e)).toList();
  }

  Future<RentalDetailsModel> getRentalDetails(String id) async {
    var resp = await httpService.doGet("/rental/$id/");
    return RentalDetailsModel.fromJson(resp);
  }

  Future<RentalResult> createRental(
      CreateRentalRequest createRentalModel) async {
    if (createRentalModel.companyId == null) {
      final CompanyInfoModel company =
          await _companyService.getLoggedUserCompany();
      createRentalModel.companyId = company.id;
    }
    var resp = await httpService.doPost(
        url: '/rental', rentXRequest: createRentalModel);
    await localStorage.remove(
        CompanyService.carFleetByCompanyId + createRentalModel.companyId!);
    return RentalResult.fromJson(resp['result']);
  }
}
