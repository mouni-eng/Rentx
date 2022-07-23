import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentx/infrastructure/exceptions.dart';
import 'package:rentx/models/user.dart';
import 'package:rentx/services/auth_service.dart';
import 'package:rentx/ui/screens/password_reset/password_reset_confirmation.dart';
import 'package:rentx/ui/screens/password_reset/password_reset_email.dart';
import 'package:rentx/ui/screens/password_reset/password_reset_submit.dart';
import 'package:rentx/view_models/password_reset_cubit/states.dart';

class PasswordResetCubit extends Cubit<PasswordResetState> {
  PasswordResetCubit() : super(PasswordResetState());
  final AuthService _authService = AuthService();

  final emailFormKey = GlobalKey<FormState>();
  final otpFormKey = GlobalKey<FormState>();
  final resetFormKey = GlobalKey<FormState>();

  static PasswordResetCubit get(context) => BlocProvider.of(context);

  final List<String> headers = [
    "tellUsYourEmail",
    "confirmationCode",
    "resetYourPassword"
  ];
  int index = 0;
  double percent = 1 / 3;
  bool isLast = false;
  PageController stepController = PageController();

  String? emailValidation;
  String? otpValidation;

  List<Widget> steps = [
    const PasswordResetEmailStep(),
    const PasswordResetConfirmationStep(),
    const PasswordResetSubmitStep()
  ];

  String? email;
  String? otpCode;
  String? password;
  String? confirmPassword;

  void onChangeEmail(String value) {
    email = value;
    emailValidation = null;
    emit(PasswordResetValueSetState());
  }

  void onChangePassword(String value) {
    password = value;
    emit(PasswordResetValueSetState());
  }

  void onChangeConfirmPassword(String value) {
    confirmPassword = value;
    emit(PasswordResetValueSetState());
  }

  void onOtpChange(String value) {
    otpCode = value;
    otpValidation = null;
    emit(PasswordResetValueSetState());
  }

  onBackStep() {
    if (percent != 1 / 3) {
      percent -= 1 / 3;
      index -= 1;
      isLast = false;
      emit(OnNextPwdResetStep(index));
    }

    stepController.previousPage(
        duration: const Duration(
          milliseconds: 750,
        ),
        curve: Curves.fastLinearToSlowEaseIn);
  }

  onNextStep() {
    if (percent != 1) {
      percent += 1 / 3;
      index += 1;
      if (index == 2) {
        isLast = true;
      }
      emit(OnNextPwdResetStep(index));
    }
    stepController.nextPage(
        duration: const Duration(
          milliseconds: 750,
        ),
        curve: Curves.fastLinearToSlowEaseIn);
  }

  onNextValidation(context) {
    if (index == 0) {
      if (emailFormKey.currentState!.validate()) {
        requestNewPassword();
      }
    } else if (index == 1) {
      if (otpFormKey.currentState!.validate()) {
        validateOtp();
      }
    } else if (index == 2) {
      if (resetFormKey.currentState!.validate()) {
        resetPassword();
      }
    }
  }

  void requestNewPassword() {
    emit(PasswordResetRequestedState());
    _authService.requestPasswordReset(email!).then((value) {
      onNextStep();
      emit(PasswordResetInitiatedState());
    }).catchError((error) {
      if (error is ApiException) {
        if (error.httpError == 404) {
          emailValidation = 'userNotFound';
        }
      }
      emailValidation = 'unknownError';
      emit(PasswordResetFailedState());
    });
  }

  void validateOtp() {
    emit(PasswordResetOtpValidatingState());
    _authService.validateOtp(email!, otpCode!).then((value) {
      if (value) {
        onNextStep();
        emit(PasswordResetOtpCodeConfirmedState());
      } else {
        otpValidation = 'validate-code-match.title';
      }
    }).catchError((error) {
      if (error is ApiException) {
        otpValidation = error.errorMessage;
      } else {
        otpValidation = 'unknownError';
      }
      emit(PasswordResetFailedState());
    });
  }

  void resetPassword() {
    emit(PasswordResetSubmittedState());
    _authService
        .resetPassword(PasswordResetRequest(
            email: email,
            password: password,
            confirmPassword: confirmPassword,
            confirmationCode: otpCode))
        .then((value) => emit(PasswordResetSuccessState()))
        .catchError((error) {
      if (error is ApiException) {
        emit(PasswordResetFailedState(code: error.errorCode));
      }
      emit(PasswordResetFailedState(code: 'unknownError'));
    });
  }
}
