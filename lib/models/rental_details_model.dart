import 'package:rentx/models/car.dart';

import 'company.dart';
import 'image.dart';

class RentalDetailsModel {
  RentalDetailsResult? result;
  bool? success;
  List<RentalsDetailsErrors>? errors;

  RentalDetailsModel({this.result, this.success, this.errors});

  RentalDetailsModel.fromJson(Map<String, dynamic> json) {
    result = json['result'] != null
        ? RentalDetailsResult.fromJson(json['result'])
        : null;
    success = json['success'];
    if (json['errors'] != null) {
      errors = <RentalsDetailsErrors>[];
      json['errors'].forEach((v) {
        errors!.add(RentalsDetailsErrors.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (result != null) {
      data['result'] = result!.toJson();
    }
    data['success'] = success;
    if (errors != null) {
      data['errors'] = errors!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RentalDetailsResult {
  String? id;
  Company? company;
  Car? car;
  double? price;
  String? status;
  String? licensePlate;
  List<FeaturedImage>? images;

  RentalDetailsResult(
      {this.id, this.company, this.car, this.price, this.status, this.images});

  RentalDetailsResult.fromJson(Map<String, dynamic> json) {
    company =
        json['company'] != null ? Company.fromJson(json['company']) : null;
    car = json['car'] != null ? Car.fromJson(json['car']) : null;
    price = json['price'];
    status = json['status'];
    licensePlate = json['licensePlate'];
    if (json['images'] != null) {
      images = <FeaturedImage>[];
      json['images'].forEach((v) {
        images!.add(FeaturedImage.fromJson(v));
      });
    }
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (company != null) {
      data['company'] = company!.toJson();
    }
    if (car != null) {
      data['car'] = car!.toJson();
    }
    data['price'] = price;
    data['status'] = status;
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    data['licensePlate'] = licensePlate;
    return data;
  }
}

class RentalsDetailsErrors {
  String? message;
  String? code;

  RentalsDetailsErrors({this.message, this.code});

  RentalsDetailsErrors.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['code'] = code;
    return data;
  }
}
