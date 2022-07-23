import 'package:rentx/extensions/string_extension.dart';
import 'package:rentx/infrastructure/request.dart';
import 'package:rentx/infrastructure/utils.dart';
import 'package:rentx/models/address.dart';

class UserSignUpRequest extends RentXSerialized {
  String? email;
  String? name;
  String? username;
  String? surname;
  DateTime? birthdate;
  UserRole? role;
  String? password;
  String? confirmPassword;
  String? personalId;
  String? phoneNumber;
  String? profilePictureId;

  UserSignUpRequest.instance();

  UserSignUpRequest(
      {this.email,
      this.name,
      this.username,
      this.surname,
      this.birthdate,
      this.role,
      this.password,
      this.confirmPassword,
      this.personalId,
      this.phoneNumber,
      this.profilePictureId});

  @override
  Map<String, dynamic> toJson() => {
        'email': email,
        'firstName': name,
        'lastName': surname,
        'username': username,
        'birthDate': birthdate ?? birthdate!.toIso8601String(),
        'role': role?.value,
        'password': password,
        'confirmPassword': confirmPassword,
        'personalId': personalId,
        'phoneNumber': phoneNumber,
        'profilePictureId': profilePictureId
      };
}

class UserDetails extends RentXSerialized {
  String? email;
  String? name;
  String? username;
  String? surname;
  DateTime? birthdate;
  UserRole? role;
  String? personalId;
  String? phoneNumber;
  String? profilePictureUrl;

  UserDetails();

  UserDetails.fromJson(Map<String, dynamic> json) {
    email = json['emailAddress'];
    name = json['firstName'];
    surname = json['lastName'];
    birthdate = parseDate(json['birthDate'])!;
    role = EnumUtil.strToEnum(
        UserRole.values, json['role'].toString().toLowerCase());
    username = json['userName'];
    profilePictureUrl = json['profilePictureUrl'];
    phoneNumber = json['phoneNumber'];
    personalId = json['personalId'];
  }

  @override
  Map<String, dynamic> toJson() => {
        'emailAddress': email,
        'firstName': name,
        'lastName': surname,
        'username': username,
        'birthDate': birthdate ?? birthdate!.toIso8601String(),
        'role': role?.value,
        'personalId': personalId,
        'phoneNumber': phoneNumber,
        'profilePictureUrl': profilePictureUrl
      };

  String getFullName() => '$name $surname';
}

class Authentication extends RentXSerialized {
  bool isAuthenticated = false;
  late List<String>? _authorities;

  Authentication.withAuthorities(final List<String> authorities) {
    _authorities = authorities;
    isAuthenticated = true;
  }

  bool hasAuthority(String auth) => _authorities?.contains(auth) ?? false;

  bool hasAnyAuthority(List<String> auth) {
    for (String authority in auth) {
      if (_authorities?.contains(authority) ?? false) {
        return true;
      }
    }
    return false;
  }

  Authentication.fromJson(Map<String, dynamic> json) {
    isAuthenticated = json['isAuthenticated'];
    _authorities = convertList(json['authorities'], (p0) => p0 ?? '');
  }

  @override
  Map<String, dynamic> toJson() =>
      {'isAuthenticated': isAuthenticated, 'authorities': _authorities};
}

enum UserRole { client, manager }

extension UserRoleExtension on UserRole {
  get value => name.capitalize();

  UserRole fromString(final String value) {
    return EnumUtil.strToEnum(UserRole.values, value);
  }
}

class CompanySignUpRequest extends RentXSerialized {
  String? email;
  String? name;
  String? description;
  String? logoFileId;
  String? phone;
  String? bannerFileId;
  bool? isFeatured;
  String? featuredPriority;
  Address? address;

  CompanySignUpRequest.instance();

  CompanySignUpRequest({
    this.email,
    this.name,
    this.description,
    this.logoFileId,
    this.bannerFileId,
    this.phone,
    this.isFeatured,
    this.featuredPriority,
    this.address,
  });

  CompanySignUpRequest.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    email = json['email'];
    phone = json['phone'];
    logoFileId = json['logoFileId'];
    bannerFileId = json['bannerFileId'];
    isFeatured = json['isFeatured'];
    featuredPriority = json['featuredPriority'];
    address = Address.fromJson(json['address']);
  }

  @override
  Map<String, dynamic> toJson() => {
        'email': email,
        'name': name,
        'description': description,
        'logoFileId': logoFileId,
        'bannerFileId': bannerFileId,
        'phone': phone,
        'isFeatured': isFeatured ?? true,
        'featuredPriority': featuredPriority ?? 0,
        'address': address!.toJson(),
      };
}

class PasswordResetRequest extends RentXSerialized {
  String? password;
  String? confirmPassword;
  String? email;
  String? confirmationCode;

  PasswordResetRequest(
      {this.password, this.confirmPassword, this.email, this.confirmationCode});

  PasswordResetRequest.fromJson(Map<String, dynamic> json) {
    password = json['password'];
    confirmPassword = json['confirmPassword'];
    email = json['email'];
    confirmationCode = json['confirmationCode'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['password'] = password;
    data['confirmPassword'] = confirmPassword;
    data['email'] = email;
    data['confirmationCode'] = confirmationCode;
    return data;
  }
}
