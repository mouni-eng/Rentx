import 'package:rentx/models/car_mdels.dart';
import 'package:rentx/services/rentx_service.dart';

class CarService extends RentXService {
  static const String _allCarModels = 'allCarModels';
  static const String _modelBrands = 'modelBrands:';

  Future<TopBrandsModel> getTopBrands() async {
    var resp = await httpService.doGet("/carModel/topBrands/");
    return TopBrandsModel.fromJson(resp);
  }

  Future<List<CarBrand>> getBrands() async {
    var resp =
        await cacheOrGet(_allCarModels, () => httpService.doGet("/carModel"));
    var cars = resp['result'] as List;
    return cars.map((e) => CarBrand.fromJson(e)).toList();
  }

  Future<List<CarBrandModel>> getModels(String brand) async {
    var resp = await cacheOrGet(
        _modelBrands + brand, () => httpService.doGet("/carModel/$brand"));
    var cars = resp['result'] as List;
    return cars.map((e) => CarBrandModel.fromJson(e)).toList();
  }
}
