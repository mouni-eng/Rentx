import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentx/infrastructure/exceptions.dart';
import 'package:rentx/models/login.dart';
import 'package:rentx/models/user.dart';
import 'package:rentx/services/auth_service.dart';
import 'package:rentx/ui/base_widget.dart';
import 'package:rentx/ui/screens/layout_screens/layout_screen.dart';
import 'package:rentx/ui/screens/manger_screens/manager_layout_screen.dart';
import 'package:rentx/view_models/booking_cubit/cubit.dart';
import 'package:rentx/view_models/home_cubit/cubit.dart';
import 'package:rentx/view_models/login_cubit/states.dart';
import 'package:rentx/view_models/profile_cubit/cubit.dart';

class LogInCubit extends Cubit<LogInStates> {
  LogInCubit() : super(LogInStates());

  static LogInCubit get(context) => BlocProvider.of(context);

  final AuthService _authService = AuthService();
  final formKey = GlobalKey<FormState>();
  String? userName, password;


  chooseUserName(String value) {
    userName = value;
    emit(OnChangedValueState());
  }

  choosePassword(String value) {
    password = value;
    emit(OnChangedValueState());
  }

   logIn(RentXContext rentXContext) {
    emit(LogInLoadingState());
    _authService
        .login(LoginRequest(username: userName, password: password)).then((value) {
      _postLogin(value, rentXContext);
      emit(LogInSuccessState());
    }).catchError((error) {
      ApiException exception = error;
      emit(LogInErrorState(
        error: exception.errorMessage,
      ));
    });
  }

   googleSignIn(RentXContext rentXContext) {
     emit(LogInLoadingState());
     _authService.loginWithGoogle().then((value) {
       _postLogin(value, rentXContext);
       emit(LogInSuccessState());
     }).catchError((error) {
       ApiException exception = error;
       emit(LogInErrorState(
         error: exception.errorMessage,
       ));
     });
  }

   facebookSignIn(RentXContext rentXContext) {
     emit(LogInLoadingState());
     _authService.loginWithFacebook().then((value) {
       _postLogin(value, rentXContext);
       emit(LogInSuccessState());
     }).catchError((error) {
       ApiException exception = error;
       emit(LogInErrorState(
         error: exception.errorMessage,
       ));
     });
  }

  _postLogin(LoginResponse loginResponse, RentXContext rentXContext) {
    ProfileCubit.get(rentXContext.context).getProfileData();
    switch (loginResponse.role) {
      case UserRole.client:
        HomeCubit.get(rentXContext.context).getHomeData();
        rentXContext.route((p0) => const LayoutScreen());
        break;
      case UserRole.manager:
        BookingCubit.get(rentXContext.context).getBookings();
        rentXContext.route((p0) => const ManagerLayoutScreen());
        break;
    }
  }

}
