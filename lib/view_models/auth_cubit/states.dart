import 'package:rentx/models/login.dart';

class AuthStates {}

class OnBackRegistrationStep extends AuthStates {}

class OnNextRegistrationStep extends AuthStates {}

class OnChangeState extends AuthStates {}

class ChooseProfileImageState extends AuthStates {}

class RegisterLoadingState extends AuthStates {}

class RegisterSuccessState extends AuthStates {}

class EmailConfirmedLoadingState extends AuthStates {}

class EmailConfirmedState extends AuthStates {
  final LoginResponse loginResponse;

  EmailConfirmedState(this.loginResponse);
}

class RegisterErrorState extends AuthStates {
  String? error;
  RegisterErrorState({this.error});
}
