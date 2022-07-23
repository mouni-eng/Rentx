enum RentXLocationType { city, fullAddress }

class RentXLocation {
  final String street;
  final String city;
  final String state;
  final String zip;
  final double latitude;
  final double longitude;
  final RentXLocationType? locationType;

  RentXLocation(
      {required this.street,
      required this.city,
      required this.state,
      required this.zip,
      this.locationType,
      required this.latitude,
      required this.longitude});

  static RentXLocation fromJson(Map<String, dynamic> json) {
    return RentXLocation(
        latitude: json['latitude'],
        longitude: json['longitude'],
        street: json['street'],
        state: json['state'],
        city: json['city'],
        zip: json['zip'],
        locationType: json['street'] != null
            ? RentXLocationType.fullAddress
            : RentXLocationType.city);
  }

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
        'street': street,
        'state': state,
        'city': city,
        'zip': zip
      };

  String fullAddress() =>
      '${_addressPart(street)}${_addressPart(city)}${_addressPart(zip)} $state';

  String _addressPart(final String? input) {
    return input != null && input.isNotEmpty ? '$input, ' : '';
  }

  @override
  String toString() {
    return 'RentXLocation{street: $street, city: $city, state: $state, zip: $zip, latitude: $latitude, longitude: $longitude, locationType: $locationType}';
  }
}

class RentXLatLong {
  double latitude;
  double longitude;

  RentXLatLong(this.latitude, this.longitude);
}
