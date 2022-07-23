import 'package:rentx/infrastructure/utils.dart';
import 'package:rentx/models/car.dart';

class TopBrandsModel {
  List<TopBrandsResult>? result;
  bool? success;

  TopBrandsModel({
    this.result,
    this.success,
  });

  TopBrandsModel.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = <TopBrandsResult>[];
      json['result'].forEach((v) {
        result!.add(TopBrandsResult.fromJson(v));
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

class TopBrandsResult {
  String? id;
  String? make;
  String? fileUploadUrl;

  TopBrandsResult({this.id, this.make, this.fileUploadUrl});

  TopBrandsResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    make = json['make'];
    fileUploadUrl = json['fileUploadUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['make'] = make;
    data['fileUploadUrl'] = fileUploadUrl;
    return data;
  }
}

class CarBrand {
  String? id;
  String? make;
  String? fileUploadUrl;
  bool? isTopBrand;

  CarBrand({this.id, this.make, this.fileUploadUrl, this.isTopBrand});

  CarBrand.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    make = json['makes'];
    fileUploadUrl = json['fileUploadUrl'];
    isTopBrand =
        json['isTopBrand'] != null ? json['isTopBrand'] as bool : false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['makes'] = make;
    data['fileUploadUrl'] = fileUploadUrl;
    data['isTopBrand'] = isTopBrand;
    return data;
  }
}

class CarBrandModel {
  String? id;
  String? makeId;
  String? model;
  CarType? type;
  String? carModelCarTypeId;

  CarBrandModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    makeId = json['makeId'];
    model = json['model'];
    type = EnumUtil.strToEnumNullable(CarType.values, json['type']);
    carModelCarTypeId = json['carModelCarTypeId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['makeId'] = makeId;
    data['model'] = model;
    data['type'] = type;
    data['carModelCarTypeId'] = carModelCarTypeId;
    return data;
  }
}
