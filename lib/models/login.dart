import 'package:rentx/infrastructure/request.dart';
import 'package:rentx/infrastructure/utils.dart';
import 'package:rentx/models/user.dart';

class LoginRequest extends RentXSerialized {
  String? username;
  String? password;

  LoginRequest.instance();

  LoginRequest({required this.username, required this.password});

  @override
  Map<String, dynamic> toJson() {
    return {'username': username, 'password': password};
  }
}

class ExternalLoginRequest extends RentXSerialized {
  final String accessToken;

  ExternalLoginRequest(this.accessToken);

  @override
  Map<String, dynamic> toJson() {
    return {'accessToken': accessToken};
  }
}

class LoginResponse extends RentXSerialized {
  late String email;
  late String name;
  late String surname;
  late DateTime birthdate;
  late UserRole role;
  late String token;

  LoginResponse(
      {required this.email,
      required this.name,
      required this.surname,
      required this.birthdate,
      required this.role,
      required this.token});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    name = json['firstName'];
    surname = json['lastName'];
    birthdate = parseDate(json['birthDate'])!;
    role = EnumUtil.strToEnum(
        UserRole.values, json['role'].toString().toLowerCase());
    token = json['token'];
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'firstName': name,
      'lastName': surname,
      'birthDate': birthdate.toIso8601String(),
      'role': role.value,
      'token': token
    };
  }
}
