import 'package:flutter/foundation.dart';
import 'package:rentx/infrastructure/request.dart';
import 'package:rentx/infrastructure/utils.dart';

import 'company.dart';

class Car {
  String? makeId;
  String? model;
  String? make;
  String? type;
  List<CarListingProperty>? properties;

  Car({this.makeId, this.model, this.type, this.properties});

  Car.fromJson(Map<String, dynamic> json) {
    makeId = json['makeId'];
    model = json['model'];
    type = json['type'];
    make = json['make'];
    if (json['properties'] != null) {
      properties = <CarListingProperty>[];
      json['properties'].forEach((v) {
        properties!.add(CarListingProperty.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['makeId'] = makeId;
    data['model'] = model;
    data['type'] = type;
    data['make'] = make;
    if (properties != null) {
      data['properties'] = properties!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  String fullName() {
    return '${make ?? ''} ${model ?? ''}';
  }
}

class CarListing extends RentXSerialized {
  late String id, name, featuredImage, location, price;

  late List<CarListingProperty>? properties;

  CarListing.instance();

  CarListing(
      {required this.id,
      required this.name,
      required this.featuredImage,
      required this.location,
      required this.price,
      required this.properties});

  CarListing.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    featuredImage = json['image'];
    location = json['location'];
    price = json['price'];
    properties = super.convertList(
        json['properties'] as List, (p0) => CarListingProperty.fromJson(p0));
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': featuredImage,
      'location': location,
      'price': price,
      'properties':
          properties == null ? [] : properties!.map((e) => e.toJson()).toList()
    };
  }
}

class CarListingProperty extends RentXSerialized {
  CarPropertyType type;
  dynamic value;

  CarListingProperty({required this.type, this.value});

  static CarListingProperty fromJson(Map<String, dynamic> json) {
    return CarListingProperty(
        type: EnumUtil.strToEnum(CarPropertyType.values, json['key']),
        value: json['value']);
  }

  @override
  Map<String, dynamic> toJson() {
    return {'key': type.name, 'value': value};
  }
}

enum CarPropertyType { fuel, engine, seats, type, year, transmission, speed }

class CarListingDetails extends CarListing {
  String? details;
  Company? company;
  List<String>? images;

  CarListingDetails(
      {required String id,
      required String name,
      required String location,
      required this.details,
      required this.company,
      required this.images,
      required String price,
      required List<CarListingProperty>? properties})
      : super(
            id: id,
            name: name,
            featuredImage: images![0],
            location: location,
            price: price,
            properties: properties);

  CarListingDetails.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    details = json['details'];
    company = Company.fromJson(json['company']);
    images = convertList(json['images'] as List, (p0) => p0);
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = super.toJson();
    json['details'] = details;
    json['company'] = company?.toJson();
    return json;
  }
}

extension CarPropertyTypeExtension on CarPropertyType {
  String get name => describeEnum(this);

  String? get icon {
    switch (this) {
      case CarPropertyType.fuel:
        return "assets/img/fuel.svg";
      case CarPropertyType.engine:
        return "assets/img/engine.svg";
      case CarPropertyType.seats:
        return "assets/img/car-seat.svg";
      case CarPropertyType.type:
        return "assets/img/sport-car.svg";
      case CarPropertyType.year:
        return "assets/img/year.svg";
      case CarPropertyType.transmission:
        return "assets/img/transs.svg";
      case CarPropertyType.speed:
        return "assets/img/speedometer.svg";
      default:
        return null;
    }
  }

  int get order {
    switch (this) {
      case CarPropertyType.fuel:
        return 0;
      case CarPropertyType.engine:
        return 1;
      case CarPropertyType.type:
        return 2;
      case CarPropertyType.year:
        return 3;
      case CarPropertyType.transmission:
        return 4;
      case CarPropertyType.seats:
        return 5;
      default:
        return 10000;
    }
  }
}

enum CarType {
  sedan,
  coupe,
  hatchback,
  suv,
  convertible,
  wagon,
  pickup,
  vanminivan,
  other
}

class CarTypeCount {
  CarType type;
  int count;

  CarTypeCount({required this.type, required this.count});
}
