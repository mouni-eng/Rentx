import 'package:rentx/models/car.dart';
import 'package:rentx/models/input_properties.dart';
import 'package:rentx/services/rentx_service.dart';

class PropertyService extends RentXService {
  static const String _propertiesKey = 'carInputProperties';

  Future<List<CarPropertyInput>> getCarProperties() async {
    var resp = await cacheOrGet(
        _propertiesKey, () => httpService.doGet('carProperty'));
    var props = resp['result'] as List;
    return props.map((e) => CarPropertyInput.fromJson(e)).toList();
  }

  Future<CarPropertyInput> getCarProperty(
      final CarPropertyType propertyType) async {
    var props = await getCarProperties();

    return props.firstWhere((element) => element.key! == propertyType);
  }
}
