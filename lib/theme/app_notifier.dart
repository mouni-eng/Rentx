/*
* File : App Theme Notifier (Listener)
* Version : 1.0.0
* */

import 'package:flutter/material.dart';
import 'package:rentx/infrastructure/localizations/language.dart';
import 'package:rentx/theme/theme_extension.dart';
import 'package:rentx/theme/theme_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_theme.dart';

class AppNotifier extends ChangeNotifier {
  AppNotifier() {
    init();
  }

  init() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    ThemeType themeType =
        sharedPreferences.getString("theme_mode").toString().toThemeType;
    _changeTheme(themeType);
    await Language.init();
    changeLanguage(Language.currentLanguage);
    notifyListeners();
  }

  updateTheme(ThemeType themeType) {
    _changeTheme(themeType);

    notifyListeners();

    updateInStorage(themeType);
  }

  Future<void> updateInStorage(ThemeType themeType) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("theme_mode", themeType.toText);
  }

  void _changeTheme(ThemeType themeType) {
    AppTheme.themeType = themeType;
    AppTheme.customTheme = AppTheme.getCustomTheme(themeType);
    AppTheme.theme = AppTheme.getTheme(themeType);
  }

  Future<void> changeLanguage(Language language, [bool notify = true]) async {
    await Language.changeLanguage(language);
    if (notify) notifyListeners();
  }
}
