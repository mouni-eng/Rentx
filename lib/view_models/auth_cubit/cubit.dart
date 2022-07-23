import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentx/infrastructure/exceptions.dart';
import 'package:rentx/infrastructure/utils.dart';
import 'package:rentx/models/file_upload.dart';
import 'package:rentx/models/user.dart';
import 'package:rentx/services/auth_service.dart';
import 'package:rentx/services/file_service.dart';
import 'package:rentx/ui/screens/auth_screens/user_registration_screens/account_data_screen.dart';
import 'package:rentx/ui/screens/auth_screens/user_registration_screens/personal_data_screen.dart';
import 'package:rentx/ui/screens/auth_screens/user_registration_screens/verify_screen.dart';
import 'package:rentx/view_models/auth_cubit/states.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthStates());

  static AuthCubit get(context) => BlocProvider.of(context);

  final FileService _fileService = FileService();
  final AuthService _authService = AuthService();

  File? profileImage;
  UserSignUpRequest signUpRequest = UserSignUpRequest.instance();

  String? confirmationCode;

  int featured = 0;
  int index = 0;
  bool isLast = false;
  double percent = 1 / 3;

  PageController controller = PageController();
  FocusNode focusNode = FocusNode();
  String? name,
      surName,
      phoneNumber,
      userName,
      email,
      category = "client",
      password,
      confirmPassword,
      pin;
  DateTime? birthDate;

  String? emailValidation;
  String? usernameValidation;
  String? emailConfirmationCodeValidation;

  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  final formKey3 = GlobalKey<FormState>();

  List<String> headers = [
    "Personal Data",
    "Account Data",
    "Verify your email",
  ];

  List<Widget> steps = [
    const PersonalDataScreen(),
    const AccountDataScreen(),
    const VerifyEmailScreen(),
  ];

  onBackStep() {
    if (percent != 1 / 3) {
      percent -= 1 / 3;
      index -= 1;
      isLast = false;
      emit(OnBackRegistrationStep());
    }

    controller.previousPage(
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
      emit(OnNextRegistrationStep());
    }
    controller.nextPage(
        duration: const Duration(
          milliseconds: 750,
        ),
        curve: Curves.fastLinearToSlowEaseIn);
  }

  chooseImage(File file) async {
    profileImage = file;
    emit(ChooseProfileImageState());
  }

  onChangeName(String value) {
    name = value;
    signUpRequest.name = value;
    emit(OnChangeState());
  }

  onChangeCategory(String value) {
    category = value;
    emit(OnChangeState());
  }

  onChangeSurName(String value) {
    surName = value;
    signUpRequest.surname = value;
    emit(OnChangeState());
  }

  onChangePhoneNumber(String value) {
    phoneNumber = value;
    signUpRequest.phoneNumber = value;
    emit(OnChangeState());
  }

  onChangeBirthDate(DateTime value) {
    birthDate = value;
    signUpRequest.birthdate = value;
    emit(OnChangeState());
  }

  onChangeUserName(String value) {
    usernameValidation = null;
    userName = value;
    signUpRequest.username = value;
    emit(OnChangeState());
  }

  onChangeEmailAddress(String value) {
    emailValidation = null;
    email = value;
    signUpRequest.email = value;
    emit(OnChangeState());
  }

  onChangePassword(String value) {
    password = value;
    signUpRequest.password = value;
    emit(OnChangeState());
  }

  onChangeConfirmPassword(String value) {
    confirmPassword = value;
    signUpRequest.confirmPassword = value;
    emit(OnChangeState());
  }

  onChangePin(String value) {
    emailConfirmationCodeValidation = null;
    confirmationCode = value;
    emit(OnChangeState());
  }

  saveUser() async {
    emit(RegisterLoadingState());
    await uploadProfilePicture();
    signUpRequest.role = signUpRequest.role ?? UserRole.client;
    signUpRequest.personalId = "";
    _authService.register(signUpRequest).then((value) {
      onNextStep();
      emit(RegisterSuccessState());
    }).catchError((error) {
      if (error is ApiException) {
        if (error.errorCode == 'SignUp') {
          emailValidation = 'SignUp.code';
        }
        if (error.errorCode == 'DuplicateUserName') {
          usernameValidation = 'DuplicateUserName.code';
        }
        emit(RegisterErrorState(error: error.errorCode));
      } else {
        emit(RegisterErrorState(error: 'unknownError'));
      }
    });
  }

  uploadProfilePicture() async {
    if (profileImage != null && signUpRequest.profilePictureId == null) {
      await _fileService
          .upload(
              'fileUpload',
              FileUploadRequest(
                  files: [profileImage!],
                  uploadType: FileUploadType.profileImage))
          .then((value) {
        if (value.fileIds != null) {
          signUpRequest.profilePictureId = value.fileIds![0];
        }
      }).catchError((error) {
        printLn(error);
      });
    }
  }

  Future<void> confirmEmail(context) async {
    emit(EmailConfirmedLoadingState());
    _authService
        .confirmAccount(signUpRequest.username!, confirmationCode!)
        .then((value) {
      emit(EmailConfirmedState(value));
    }).catchError((err) {
      if (err is ApiException) {
        if (err.errorCode == 'ConfirmEmail') {
          emailConfirmationCodeValidation = 'ConfirmEmail.code';
        }
        emit(RegisterErrorState(error: err.errorCode));
      } else {
        emit(RegisterErrorState(error: 'unknownError'));
      }
    });
  }

  onNextValidation(context) {
    if (index == 0) {
      if (formKey1.currentState!.validate() && birthDate != null) {
        onNextStep();
      }
    } else if (index == 1) {
      if (formKey2.currentState!.validate()) {
        saveUser();
      }
    } else {
      if (formKey3.currentState!.validate()) {
        confirmEmail(context);
      }
    }
  }
}
