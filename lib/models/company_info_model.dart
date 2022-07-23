import 'package:rentx/models/address.dart';

class CompanyInfoModel {
  String? id;
  String? name;
  String? description;
  Address? address;
  String? email;
  String? phone;
  String? logoUrl;
  String? bannerUrl;
  bool? isFeatured;
  int? featuredPriority;
  String? status;

  CompanyInfoModel(
      {this.id,
      this.name,
      this.description,
      this.address,
      this.email,
      this.phone,
      this.logoUrl,
      this.bannerUrl,
      this.isFeatured,
      this.featuredPriority,
      this.status});

  CompanyInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    address =
        json['address'] != null ? Address.fromJson(json['address']) : null;
    email = json['email'];
    phone = json['phone'];
    logoUrl = json['logoUrl'];
    bannerUrl = json['bannerUrl'];
    isFeatured = json['isFeatured'];
    featuredPriority = json['featuredPriority'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    if (address != null) {
      data['address'] = address!.toJson();
    }
    data['email'] = email;
    data['phone'] = phone;
    data['logoUrl'] = logoUrl;
    data['bannerUrl'] = bannerUrl;
    data['isFeatured'] = isFeatured;
    data['featuredPriority'] = featuredPriority;
    data['status'] = status;
    return data;
  }
}
