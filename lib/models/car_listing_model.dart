import 'dart:io';

import 'package:rentx/infrastructure/request.dart';

import 'car.dart';

class CarListingModel extends RentXSerialized {
  String? make, model, id, liscencePlate, price;
  List<ImageModel>? images;
  List<CarListingProperty>? properties;

  CarListingModel(
      {this.id,
      this.make,
      this.model,
      this.images,
      this.liscencePlate,
      this.properties,
      this.price});

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'make': make,
      'model': model,
      'liscencePlate': liscencePlate,
      'price': price,
      'properties':
          properties == null ? [] : properties!.map((e) => e.toJson()).toList(),
      'images': images == null ? [] : images!.map((e) => e.toJson()).toList()
    };
  }
}

class ImageModel extends RentXSerialized {
  File? file;
  bool? featured;

  ImageModel({this.file, this.featured});

  @override
  Map<String, dynamic> toJson() {
    return {
      "file": file,
      "featured": featured,
    };
  }
}

class CarModel {
  String? make;
  List<CarBrandModel>? carModels = [];

  CarModel({this.carModels, this.make});

  CarModel.fromJson(Map<String, dynamic> json) {
    make = json['make'];
    json["model"]
        .forEach((element) => carModels!.add(CarBrandModel.fromJson(element)));
  }
}

class CarBrandModel {
  String? name, carType;

  CarBrandModel({
    this.name,
    this.carType,
  });

  CarBrandModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    carType = json['category'];
  }
}
