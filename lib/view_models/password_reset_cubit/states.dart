class PasswordResetState {}

class OnNextPwdResetStep extends PasswordResetState {
  final int step;

  OnNextPwdResetStep(this.step);
}

class PasswordResetValueSetState extends PasswordResetState {}

class PasswordResetRequestedState extends PasswordResetState {}

class PasswordResetInitiatedState extends PasswordResetState {}

class PasswordResetOtpValidatingState extends PasswordResetState {}

class PasswordResetOtpCodeConfirmedState extends PasswordResetState {}

class PasswordResetFailedState extends PasswordResetState {
  final String? code;

  PasswordResetFailedState({this.code});
}

class PasswordResetSubmittedState extends PasswordResetState {}

class PasswordResetSuccessState extends PasswordResetState {}
