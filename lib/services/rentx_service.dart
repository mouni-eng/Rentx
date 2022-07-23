import 'package:rentx/infrastructure/http_service.dart';
import 'package:rentx/infrastructure/local_storage.dart';

class RentXService {
  final HttpService _httpService = HttpService();
  final LocalStorage _localStorage = LocalStorage();

  HttpService get httpService => _httpService;

  LocalStorage get localStorage => _localStorage;

  Future<Map<String, dynamic>> cacheOrGet(final String cacheKey,
      Future<Map<String, dynamic>> Function() supplier) async {
    final cacheValue = await _localStorage.getJson(cacheKey);
    if (cacheValue.isEmpty) {
      final apiValue = await supplier.call();
      await _localStorage.setJson(cacheKey, apiValue);
      return apiValue;
    }
    return cacheValue;
  }
}
