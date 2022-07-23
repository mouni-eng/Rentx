import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:rentx/extensions/string_extension.dart';
import 'package:rentx/infrastructure/request.dart';
import 'package:rentx/infrastructure/utils.dart';
import 'package:rentx/models/car.dart';
import 'package:rentx/models/company.dart';
import 'package:rentx/models/image.dart';
import 'package:rentx/ui/base_widget.dart';

class RentalModel {
  List<RentalResult>? result;
  bool? success;

  RentalModel({this.result, this.success});

  RentalModel.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = <RentalResult>[];
      json['result'].forEach((v) {
        result!.add(RentalResult.fromJson(v));
      });
    }
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    data['success'] = success;
    return data;
  }
}

class RentalCompany {
  late String? id;
  late double? latitude;
  late double? longitude;

  RentalCompany.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() =>
      {'id': id, 'latitude': latitude, 'longitude': longitude};
}

class RentalResult {
  String? id;
  Car? car;
  String? carModelCarTypeId;
  CompanyLocation? company;
  double? price;
  RentalStatus? status;
  double? rating;
  String? licensePlate;
  List<FeaturedImage>? rentalImages;
  List<CarListingProperty>? rentalProperties;

  RentalResult(
      {this.id,
      this.car,
      this.carModelCarTypeId,
      this.company,
      this.price,
      this.status,
      this.rating,
      this.licensePlate,
      this.rentalImages,
      this.rentalProperties});

  RentalResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    car = json['car'] != null ? Car.fromJson(json['car']) : null;
    carModelCarTypeId = json['carModelCarTypeId'];
    company = CompanyLocation.fromJson(json['company'] ?? {});
    price = json['price'];
    rating = json['rating'];
    status = EnumUtil.strToEnumNullable(RentalStatus.values, json['status']);
    licensePlate = json['licensePlate'];
    if (json['rentalImages'] != null) {
      rentalImages = <FeaturedImage>[];
      json['rentalImages'].forEach((v) {
        rentalImages!.add(FeaturedImage.fromJson(v));
      });
    }
    if (json['rentalProperties'] != null) {
      rentalProperties = <CarListingProperty>[];
      json['rentalProperties'].forEach((v) {
        rentalProperties!.add(CarListingProperty.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (car != null) {
      data['car'] = car!.toJson();
    }
    data['carModelCarTypeId'] = carModelCarTypeId;
    data['company'] = company?.toJson();
    data['price'] = price;
    data['rating'] = rating;
    data['status'] = status?.value();
    data['licensePlate'] = licensePlate;
    if (rentalImages != null) {
      data['rentalImages'] = rentalImages!.map((v) => v.toJson()).toList();
    }
    if (rentalProperties != null) {
      data['rentalProperties'] =
          rentalProperties!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  CarListingProperty? getProperty(CarPropertyType type) {
    if (rentalProperties == null || rentalProperties!.isEmpty) {
      return null;
    }
    try {
      return rentalProperties!.firstWhere((element) => element.type == type);
    } catch (e) {
      return null;
    }
  }
}

class CreateRentalRequest extends RentXSerialized {
  String? carModelCarTypeId;
  String? companyId;
  double? price;
  String? status;
  String? licensePlate;
  List<UploadFeaturedImage>? images;
  List<CarListingProperty>? properties;

  CreateRentalRequest(
      {this.carModelCarTypeId,
      this.companyId,
      this.price,
      this.status,
      this.licensePlate,
      this.images,
      this.properties});

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['carModelCarTypeId'] = carModelCarTypeId;
    data['companyId'] = companyId;
    data['price'] = price;
    data['status'] = status;
    data['licensePlate'] = licensePlate;
    data['images'] = images?.map((e) => e.toJson()).toList();
    data['properties'] = properties?.map((e) => e.toJson()).toList();
    return data;
  }
}

enum RentalStatus { available, unavailable }

extension RentalStatusExtension on RentalStatus {
  String get name => describeEnum(this);

  String value() {
    return name.capitalize();
  }

  Color getTextColor(RentXContext context) {
    switch (this) {
      case RentalStatus.available:
        return context.theme.customTheme.onApprove;
      case RentalStatus.unavailable:
        return context.theme.customTheme.onPending;
      default:
        throw 'No color mapped for: ' + name;
    }
  }

  Color getBadgeColor(RentXContext context) {
    switch (this) {
      case RentalStatus.available:
        return context.theme.customTheme.approve;
      case RentalStatus.unavailable:
        return context.theme.customTheme.pending;
      default:
        throw 'No color mapped for: ' + name;
    }
  }
}
