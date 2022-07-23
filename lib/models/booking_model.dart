import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rentx/extensions/string_extension.dart';
import 'package:rentx/infrastructure/request.dart';
import 'package:rentx/infrastructure/utils.dart';
import 'package:rentx/models/address.dart';
import 'package:rentx/models/company.dart';
import 'package:rentx/ui/base_widget.dart';

class ManagerBookingsModel {
  ManagerCompany? company;
  List<CompanyBooking>? bookings;

  ManagerBookingsModel({this.company, this.bookings});

  ManagerBookingsModel.fromJson(Map<String, dynamic> json) {
    company = json['company'] != null
        ? ManagerCompany.fromJson(json['company'])
        : null;
    if (json['bookings'] != null) {
      bookings = <CompanyBooking>[];
      json['bookings'].forEach((v) {
        bookings!.add(CompanyBooking.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (company != null) {
      data['company'] = company!.toJson();
    }
    if (bookings != null) {
      data['bookings'] = bookings!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ManagerCompany {
  String? name;
  Address? address;

  ManagerCompany({this.name, this.address});

  ManagerCompany.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    address =
        json['address'] != null ? Address.fromJson(json['address']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    if (address != null) {
      data['address'] = address!.toJson();
    }
    return data;
  }
}

class CompanyBooking {
  BookingUser? user;
  BookingCar? car;
  BookingStatus? status;
  DateTime? fromDate;
  DateTime? toDate;
  double? totalPrice, pricePerDay;
  List<Fees>? fees;
  String? id;

  CompanyBooking(
      {this.user,
      this.status,
      this.fromDate,
      this.toDate,
      this.totalPrice,
      this.pricePerDay,
      this.fees,
      this.car,
      this.id});

  CompanyBooking.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? BookingUser.fromJson(json['user']) : null;
    status = EnumUtil.strToEnumNullable(BookingStatus.values, json['status']);
    fromDate = DateTime.tryParse(json['fromDate']);
    toDate = DateTime.tryParse(json['toDate']);
    totalPrice = json['totalPrice'];
    pricePerDay = json['pricePerDay'];
    if (json['fees'] != null) {
      fees = <Fees>[];
      json['fees'].forEach((v) {
        fees!.add(Fees.fromJson(v));
      });
    }
    car = BookingCar.fromJson(json['car']);
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['status'] = status;
    data['fromDate'] = fromDate?.toIso8601String();
    data['toDate'] = toDate?.toIso8601String();
    data['totalPrice'] = totalPrice;
    data['id'] = id;
    data['car'] = car?.toJson();
    return data;
  }
}

class Fees {
  FeesType? type;
  double? value;

  Fees({
    this.type,
    this.value,
  });

  Fees.fromJson(Map<String, dynamic> json) {
    type = EnumUtil.strToEnumNullable(FeesType.values, json['type']);
    value = json['lastName'];
  }
}

enum FeesType { serviceFee }

class BookingUser {
  String? firstName;
  String? lastName;
  String? imageUrl;
  String? phoneNumber;
  String? email;

  BookingUser({this.firstName, this.lastName, this.imageUrl});

  BookingUser.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    imageUrl = json['imageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['imageUrl'] = imageUrl;
    return data;
  }

  String get fullName => '$firstName $lastName';
}

class BookingCar {
  String? make;
  String? model;
  String? licensePlate;

  String get fullName => '$make $model';

  BookingCar({this.make, this.model, this.licensePlate});

  BookingCar.fromJson(Map<String, dynamic> json) {
    make = json['make'];
    model = json['model'];
    licensePlate = json['licensePlate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['make'] = make;
    data['model'] = model;
    data['licensePlate'] = licensePlate;
    return data;
  }
}

class UserBooking extends RentXSerialized {
  String? id;
  BookingStatus? status;
  DateTime? fromDate;
  DateTime? toDate;
  double? pricePerDay;
  double? totalPrice;
  BookingCar? car;
  String? companyName;
  String? featuredImageUrl;

  UserBooking(
      {this.id,
      this.status,
      this.fromDate,
      this.toDate,
      this.totalPrice,
      this.car,
      this.companyName});

  UserBooking.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = EnumUtil.strToEnumNullable(BookingStatus.values, json['status']);
    fromDate = parseDate(json['fromDate']);
    toDate = parseDate(json['toDate']);
    totalPrice = json['totalPrice'];
    pricePerDay = json['pricePerDay'] ?? totalPrice;
    featuredImageUrl = json['featuredImageUrl'];
    car = json['car'] != null ? BookingCar.fromJson(json['car']) : null;
    companyName = json['companyName'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['status'] = status?.name.capitalize();
    data['fromDate'] = fromDate?.toIso8601String();
    data['toDate'] = toDate?.toIso8601String();
    data['totalPrice'] = totalPrice;
    data['totalPrice'] = pricePerDay;
    data['featuredImageUrl'] = featuredImageUrl;
    if (car != null) {
      data['car'] = car!.toJson();
    }
    data['companyName'] = companyName;
    return data;
  }
}

class UserBookingDetails extends RentXSerialized {
  String? id;
  BookingStatus? status;
  DateTime? fromDate;
  DateTime? toDate;
  double? pricePerDay;
  double? totalPrice;
  BookingCar? car;
  Company? company;
  String? featuredImageUrl;

  UserBookingDetails.fromJson(Map<String, dynamic> json) {
    print(json);
    id = json['id'];
    status = EnumUtil.strToEnumNullable(BookingStatus.values, json['status']);
    fromDate = parseDate(json['fromDate']);
    toDate = parseDate(json['toDate']);
    totalPrice = json['totalPrice'];
    pricePerDay = totalPrice! / toDate!.difference(fromDate!).inDays;
    featuredImageUrl = json['featuredImageUrl'];
    car = json['car'] != null ? BookingCar.fromJson(json['car']) : null;
    company = Company.fromJson(json['company'] ?? {});
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['status'] = status?.name.capitalize();
    data['fromDate'] = fromDate?.toIso8601String();
    data['toDate'] = toDate?.toIso8601String();
    data['totalPrice'] = totalPrice;
    data['totalPrice'] = pricePerDay;
    data['featuredImageUrl'] = featuredImageUrl;
    data['car'] = car?.toJson();
    data['company'] = company?.toJson();
    return data;
  }
}

enum BookingStatus { pending, rejected, approved, cancelled, expired }

extension BookingStatusExtension on BookingStatus {
  Color getTextColor(RentXContext context) {
    switch (this) {
      case BookingStatus.approved:
        return context.theme.customTheme.onApprove;
      case BookingStatus.pending:
        return context.theme.customTheme.onPending;
      case BookingStatus.rejected:
        return context.theme.customTheme.onRejected;
      default:
        throw 'No color mapped for: ' + name;
    }
  }

  Color getBadgeColor(RentXContext context) {
    switch (this) {
      case BookingStatus.approved:
        return context.theme.customTheme.approve;
      case BookingStatus.pending:
        return context.theme.customTheme.pending;
      case BookingStatus.rejected:
        return context.theme.customTheme.rejected;
      default:
        throw 'No color mapped for: ' + name;
    }
  }
}

class CreateBookingResult {
  String? rentalId;
  String? fromDate;
  String? toDate;
  double? price;
  String? comments;
  String? paymentMethod;

  CreateBookingResult(
      {this.rentalId,
      this.fromDate,
      this.toDate,
      this.price,
      this.comments,
      this.paymentMethod});

  CreateBookingResult.fromJson(Map<String, dynamic> json) {
    rentalId = json['rentalId'];
    fromDate = json['fromDate'];
    toDate = json['toDate'];
    price = json['price'];
    comments = json['comments'];
    paymentMethod = json['paymentMethod'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rentalId'] = rentalId;
    data['fromDate'] = fromDate;
    data['toDate'] = toDate;
    data['price'] = price;
    data['comments'] = comments;
    data['paymentMethod'] = paymentMethod;
    return data;
  }
}
