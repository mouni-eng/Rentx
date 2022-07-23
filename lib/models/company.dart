import 'address.dart';

class CompanyLocation {
  double? latitude;
  double? longitude;

  CompanyLocation({this.latitude, this.longitude});

  CompanyLocation.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}

class Company {
  String? id;
  String? logoUrl;
  String? bannerUrl;
  String? name;
  String? description;
  Address? address;

  Company(
      {this.id,
      this.logoUrl,
      this.bannerUrl,
      this.name,
      this.address,
      this.description});

  Company.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    logoUrl = json['logoUrl'];
    bannerUrl = json['bannerUrl'];
    name = json['name'];
    description = json['description'];
    address =
        json['address'] != null ? Address.fromJson(json['address']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['logoUrl'] = logoUrl;
    data['bannerUrl'] = bannerUrl;
    data['name'] = name;
    data['description'] = description;
    if (address != null) {
      data['address'] = address!.toJson();
    }
    return data;
  }
}
