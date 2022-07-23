import 'package:rentx/infrastructure/local_storage.dart';
import 'package:rentx/models/company_info_model.dart';
import 'package:rentx/models/rental_model.dart';
import 'package:rentx/services/rentx_service.dart';

class CompanyService extends RentXService {
  static const String companyById = "companyWithID:";
  static const String carFleetByCompanyId = "carFleetByCompanyId:";

  Future<CompanyInfoModel> getLoggedUserCompany() async {
    var resp = await cacheOrGet(LocalStorageKeys.loggedUserCompany,
        () => httpService.doGet("/company/loggedUser/"));
    return CompanyInfoModel.fromJson(resp["result"]);
  }

  Future<CompanyInfoModel> getCompanyInfo(final String id) async {
    var resp = await cacheOrGet(
        companyById + id, () => httpService.doGet("/company/$id"));
    return CompanyInfoModel.fromJson(resp["result"]);
  }

  Future<RentalModel> getCarFleet(String id) async {
    var resp = await cacheOrGet(carFleetByCompanyId + id,
        () => httpService.doGet("/company/$id/rental/"));
    return RentalModel.fromJson(resp);
  }
}
