import 'package:rentx/extensions/string_extension.dart';
import 'package:rentx/infrastructure/request.dart';
import 'package:rentx/infrastructure/utils.dart';
import 'package:rentx/models/car.dart';
import 'package:rentx/models/rental_model.dart';

class RentalFilterModel extends RentXSerialized {
  double? minPrice;
  double? maxPrice;
  CarType? carType;
  Map<CarPropertyType, dynamic>? properties;
  RentalStatus? rentalStatus;
  double? latitude;
  double? longitude;
  int? radius;
  PaginationModel? paginationModel;
  Sort? sort;
  DateTime? fromDate, toDate;

  RentalFilterModel(
      {this.minPrice = 0,
      this.maxPrice = 0,
      this.carType,
      this.properties,
      this.rentalStatus,
      this.latitude,
      this.longitude,
      this.radius,
      this.paginationModel,
      this.sort,
      this.fromDate,
      this.toDate});

  RentalFilterModel.fromJson(Map<String, dynamic> json) {
    minPrice = json['minPrice'];
    maxPrice = json['maxPrice'];
    fromDate = json['fromDate'];
    toDate = json['toDate'];
    carType = EnumUtil.strToEnumNullable(CarType.values, json['carType']);
    properties = json['properties'] != null
        ? (json['properties'] as Map).map((key, value) => MapEntry(
            EnumUtil.strToEnum(
                CarPropertyType.values, key.toString().toLowerCase()),
            value))
        : null;
    rentalStatus =
        EnumUtil.strToEnumNullable(RentalStatus.values, json['rentalStatus']);
    latitude = json['latitude'];
    longitude = json['longitude'];
    radius = json['radius'];
    paginationModel = json['paginationModel'] != null
        ? PaginationModel.fromJson(json['paginationModel'])
        : null;
    sort = json['sort'] != null ? Sort.fromJson(json['sort']) : null;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    ifNotNull(minPrice, () => data['minPrice'] = minPrice);
    ifNotNull(maxPrice, () => data['maxPrice'] = maxPrice);
    ifNotNull(fromDate, () => data['fromDate'] = fromDate);
    ifNotNull(toDate, () => data['toDate'] = toDate);
    ifNotNull(carType, () => data['carType'] = carType?.name.capitalize());
    ifNotNull(properties,
        () => properties!.map((key, value) => MapEntry(key.name, value)));
    ifNotNull(rentalStatus, () => rentalStatus?.value());
    ifNotNull(latitude, () => data['latitude'] = latitude);
    ifNotNull(longitude, () => data['longitude'] = longitude);
    ifNotNull(radius, () => data['radius'] = radius);
    ifNotNull(paginationModel,
        () => data['paginationModel'] = paginationModel!.toJson());
    ifNotNull(sort, () => data['sort'] = sort!.toJson());
    return data;
  }
}

class PaginationModel {
  int? pageNumber;
  int? pageSize;

  PaginationModel({this.pageNumber = 0, this.pageSize = 0});

  PaginationModel.fromJson(Map<String, dynamic> json) {
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pageNumber'] = pageNumber;
    data['pageSize'] = pageSize;
    return data;
  }
}

class Sort {
  String? sortBy;
  String? sortOrder;

  Sort({this.sortBy = "Date", this.sortOrder = "DESC"});

  Sort.fromJson(Map<String, dynamic> json) {
    sortBy = json['sortBy'];
    sortOrder = json['sortOrder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sortBy'] = sortBy;
    data['sortOrder'] = sortOrder;
    return data;
  }
}
