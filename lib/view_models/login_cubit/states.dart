class LogInStates {}

class OnChangedValueState extends LogInStates {}

class LogInSuccessState extends LogInStates {}

class LogInErrorState extends LogInStates {
  String? error;
  LogInErrorState({this.error});
}

class LogInLoadingState extends LogInStates {}