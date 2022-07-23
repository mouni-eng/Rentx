class CompanyAuthStates {}

class OnBackRegistrationStep extends CompanyAuthStates {}

class OnNextRegistrationStep extends CompanyAuthStates {}

class OnChangeState extends CompanyAuthStates {}

class ChooseProfileImageState extends CompanyAuthStates {}

class CompanyRegisterLoadingState extends CompanyAuthStates {}

class CompanyRegisterSuccessState extends CompanyAuthStates {}

class CompanyRegisterErrorState extends CompanyAuthStates {
  String? error;
  CompanyRegisterErrorState({this.error});
}