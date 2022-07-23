import 'car.dart';
import 'company.dart';
import 'image.dart';

class BestDealsRental {
  List<BestDealsResult>? result;
  bool? success;

  BestDealsRental({this.result, this.success});

  BestDealsRental.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = <BestDealsResult>[];
      json['result'].forEach((v) {
        result!.add(BestDealsResult.fromJson(v));
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

class BestDealsResult {
  Company? company;
  Car? car;
  double? price;
  String? status;
  List<FeaturedImage>? images;

  BestDealsResult(
      {this.company, this.car, this.price, this.status, this.images});

  BestDealsResult.fromJson(Map<String, dynamic> json) {
    company =
        json['company'] != null ? Company.fromJson(json['company']) : null;
    car = json['car'] != null ? Car.fromJson(json['car']) : null;
    price = json['price'];
    status = json['status'];
    if (json['images'] != null) {
      images = <FeaturedImage>[];
      json['images'].forEach((v) {
        images!.add(FeaturedImage.fromJson(v));
      });
    }
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
    return data;
  }
}
