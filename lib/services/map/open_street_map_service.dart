import 'dart:convert';

import 'package:http/http.dart';
import 'package:rentx/infrastructure/exceptions.dart';
import 'package:rentx/models/location.dart';
import 'package:rentx/services/map/map_service.dart';

class OpenStreetMapService implements MapService {
  static const String _searchApi =
      'https://nominatim.openstreetmap.org/search?format=jsonv2&addressdetails=1';

  static const String _reverseLookupApi =
      "https://nominatim.openstreetmap.org/reverse?format=jsonv2&addressdetails=1";

  @override
  MapProvider provider() {
    return MapProvider.openStreet;
  }

  @override
  Future<List<RentXLocation>> query(final String address) async {
    final Uri fullUri = Uri.parse('$_searchApi}&q=$address}&&countrycodes=al');
    var response = await get(fullUri);
    if (response.statusCode != 200) {
      throw ApiException('openStreet-error', response.body);
    }
    List resp = jsonDecode(response.body) as List;
    return resp.map((e) => _mapLocation(e)).toList();
  }

  @override
  Future<RentXLocation> exactLocation(RentXLatLong coordinates) async {
    final Uri fullUri = Uri.parse(
        '$_reverseLookupApi}&lat=${coordinates.latitude}&lon=${coordinates.longitude}');
    var response = await get(fullUri);
    if (response.statusCode != 200) {
      throw ApiException('openStreet-error', response.body);
    }
    dynamic openStreetLocation = jsonDecode(response.body);
    return _mapLocation(openStreetLocation);
  }

  RentXLocation _mapLocation(dynamic openStreetLocation) {
    var address = openStreetLocation['address'] ?? {};
    return RentXLocation(
        latitude: double.parse(
          openStreetLocation['lat'],
        ),
        longitude: double.parse(openStreetLocation['lon']),
        zip: address['postcode'] ?? '',
        state: address['country'] ?? '',
        city: address['city'] ?? '',
        locationType: (address?['road'] ?? '').isNotEmpty
            ? RentXLocationType.fullAddress
            : RentXLocationType.city,
        street: address?['road'] ?? '');
  }
}
