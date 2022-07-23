import 'package:rentx/models/user.dart';

class ProfileStates {}

class OnChangeProfileImageState extends ProfileStates {}

class SwitchThemeState extends ProfileStates {}

class SwitchLangState extends ProfileStates {}

class SwitchCurrencyState extends ProfileStates {}

class GetUserDetailsLoadingState extends ProfileStates {}

class GetUserDetailsSuccessState extends ProfileStates {}

class GetUserDetailsErrorState extends ProfileStates {}

class LoggedOutState extends ProfileStates {
  final UserRole loggedUserRole;

  LoggedOutState(this.loggedUserRole);
}
