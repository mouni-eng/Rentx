import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:rentx/infrastructure/utils.dart';
import 'package:rentx/models/currency.dart';
import 'package:rentx/models/user.dart';
import 'package:rentx/services/auth_service.dart';
import 'package:rentx/services/currency_service.dart';
import 'package:rentx/theme/app_notifier.dart';
import 'package:rentx/theme/theme_type.dart';
import 'package:rentx/view_models/profile_cubit/states.dart';

import '../../infrastructure/localizations/language.dart';

class ProfileCubit extends Cubit<ProfileStates> {
  ProfileCubit() : super(ProfileStates());

  static ProfileCubit get(context) => BlocProvider.of(context);

  bool isDark = false;
  File? profileImage;
  final AuthService _authService = AuthService();
  final CurrencyService _currencyService = CurrencyService();
  UserDetails? userDetails;
  Currency? activeCurrency;
  Language activeLanguage = Language.currentLanguage;

  chooseProfileImage(File file) async {
    profileImage = file;
    emit(OnChangeProfileImageState());
  }

  getProfileData() {
    emit(GetUserDetailsLoadingState());
    _authService.loggedUserDetails().then((value) {
      userDetails = value;
      print(value.profilePictureUrl.toString());
      emit(GetUserDetailsSuccessState());
    }).catchError((error) {
      emit(GetUserDetailsErrorState());
    });

    _currencyService.getCurrency().then((value) => activeCurrency = value);
  }

  switchTheme(BuildContext context) {
    isDark = !isDark;
    if (isDark) {
      Provider.of<AppNotifier>(context, listen: false)
          .updateTheme(ThemeType.dark);
    } else {
      Provider.of<AppNotifier>(context, listen: false)
          .updateTheme(ThemeType.light);
    }
    emit(SwitchThemeState());
  }

  switchLanguage(final String lang) {
    final Language language = Language.getLanguageFromCode(lang);
    Language.changeLanguage(language).then((value) {
      activeLanguage = language;
      emit(SwitchLangState());
    });
  }

  switchCurrency(final String currency) {
    final Currency currencyEnum = EnumUtil.strToEnum(Currency.values, currency);
    _currencyService.switchCurrency(currencyEnum).then((value) {
      activeCurrency = value;
      emit(SwitchCurrencyState());
    });
  }

  logout() {
    _authService.logout().then((value) {
      emit(LoggedOutState(userDetails!.role!));
      userDetails = null;
    });
  }
}
