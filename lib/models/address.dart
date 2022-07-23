class Address {
  String? street;
  String? street2;
  String? notes;
  City? city;
  double? latitude;
  double? longitude;
  int? zip;

  Address(
      {this.street,
      this.street2,
      this.notes,
      this.city,
      this.latitude,
      this.longitude,
      this.zip});

  Address.fromJson(Map<String, dynamic> json) {
    street = json['street'];
    street2 = json['street2'];
    notes = json['notes'];
    city = json['city'] != null ? City.fromJson(json['city']) : null;
    latitude = double.parse(json['latitude'] ?? '0');
    longitude = double.parse(json['longitude'] ?? '0');
    zip = json['zip'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['street'] = street;
    data['street2'] = street2;
    data['notes'] = notes;
    if (city != null) {
      data['city'] = city!.toJson();
    }
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['zip'] = zip;
    return data;
  }

  String fullAddress() =>
      '${_addressPart(street)}${_addressPart(city?.name)}${_addressPart(zip?.toString())} ${_nvl(city?.country)}';

  String streetAndCity() => '${_addressPart(street)}${_nvl(city?.name)}';

  String cityAndCountry() =>
      '${_addressPart(city?.name)} ${_nvl(city?.country)}';

  String _addressPart(final String? input) {
    return input != null && input.isNotEmpty ? '$input, ' : '';
  }

  String _nvl(final String? input) {
    return input ?? '';
  }
}

class City {
  String? name;
  String? countryCode;
  String? country;

  City({this.name, this.countryCode, this.country});

  City.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    countryCode = json['countryCode'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['countryCode'] = countryCode;
    data['country'] = country;
    return data;
  }
}
