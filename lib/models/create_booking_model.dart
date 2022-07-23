import 'package:rentx/extensions/string_extension.dart';
import 'package:rentx/infrastructure/request.dart';
import 'package:rentx/infrastructure/utils.dart';

class CreateBookingModel extends RentXSerialized {
  String? rentalId;
  DateTime? fromDate;
  DateTime? toDate;
  double? price;
  String? comments;
  PaymentMethod? paymentMethod;
  User? user;

  CreateBookingModel(
      {this.rentalId,
      this.fromDate,
      this.toDate,
      this.price,
      this.comments,
      this.paymentMethod,
      this.user});

  CreateBookingModel.fromJson(Map<String, dynamic> json) {
    rentalId = json['rentalId'];
    fromDate = parseDate(json['fromDate']);
    toDate = parseDate(json['toDate']);
    price = json['price'];
    comments = json['comments'];
    paymentMethod =
        EnumUtil.strToEnumNullable(PaymentMethod.values, json['paymentMethod']);
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rentalId'] = rentalId;
    data['fromDate'] = fromDate?.toIso8601String();
    data['toDate'] = toDate?.toIso8601String();
    data['price'] = price;
    data['comments'] = comments;
    data['paymentMethod'] = paymentMethod?.name.capitalize();
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

enum PaymentMethod { cash }

class User {
  String? email;
  String? name;
  String? surName;
  String? confirmEmail;
  String? phoneNumber;

  User(
      {this.email,
      this.name,
      this.surName,
      this.confirmEmail,
      this.phoneNumber});

  User.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    name = json['name'];
    surName = json['surName'];
    confirmEmail = json['confirmEmail'];
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['name'] = name;
    data['surName'] = surName;
    data['confirmEmail'] = confirmEmail;
    data['phoneNumber'] = phoneNumber;
    return data;
  }
}
