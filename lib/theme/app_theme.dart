/*
* File : App Theme
* Version : 1.0.0
* */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentx/constants.dart';
import 'package:rentx/theme/theme_type.dart';

import 'custom_theme.dart';

export 'custom_theme.dart';

class AppTheme {
  static ThemeType themeType = ThemeType.light;
  static TextDirection textDirection = TextDirection.ltr;

  static CustomTheme customTheme = getCustomTheme();
  static ThemeData theme = getTheme();

  AppTheme._();

  static ThemeData getTheme([ThemeType? themeType]) {
    themeType = themeType ?? AppTheme.themeType;
    if (themeType == ThemeType.light) return lightTheme;
    return darkTheme;
  }

  static CustomTheme getCustomTheme([ThemeType? themeType]) {
    themeType = themeType ?? AppTheme.themeType;
    if (themeType == ThemeType.light) return CustomTheme.lightCustomTheme;
    return CustomTheme.darkCustomTheme;
  }

  /// -------------------------- Light Theme  -------------------------------------------- ///
  static final ThemeData lightTheme = ThemeData(
    /// Brightness
    brightness: Brightness.light,

    /// Primary Color
    primaryColor: const Color(0xff2E70E2),

    /// Scaffold and Background color
    backgroundColor: const Color(0xffffffff),
    scaffoldBackgroundColor: const Color(0xffffffff),
    canvasColor: Colors.transparent,

    scrollbarTheme: ScrollbarThemeData(
      thumbVisibility: MaterialStateProperty.all(true),
      thickness: MaterialStateProperty.all(5),
      thumbColor: MaterialStateProperty.all(kPrimaryColor),
      radius: const Radius.circular(10),
      minThumbLength: 5,
    ),

    /// AppBar Theme
    appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xffEEF2FA),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.light,
        ),
        iconTheme: IconThemeData(color: Color(0xff21262E)),
        actionsIconTheme: IconThemeData(color: Color(0xff2E70E2))),

    /// Card Theme
    cardTheme: const CardTheme(color: Color(0xffEEF2FA)),

    textTheme: GoogleFonts.poppinsTextTheme(),

    /// Colorscheme
    colorScheme: const ColorScheme.light(
        primary: Color(0xff2E70E2),
        onPrimary: Color(0xffeeeeee),
        secondary: Color(0xff21262E),
        onSecondary: Color(0xffeeeeee),
        surface: Color(0xffE5EDFA),
        background: Color(0xffEEF2FA),
        onBackground: Color(0xff21262E)),

    /// Floating Action Theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: const Color(0xff3C4EC5),
        splashColor: const Color(0xffeeeeee).withAlpha(100),
        highlightElevation: 8,
        elevation: 4,
        focusColor: const Color(0xff3C4EC5),
        hoverColor: const Color(0xff3C4EC5),
        foregroundColor: const Color(0xffeeeeee)),

    /// Divider Theme
    dividerTheme:
        const DividerThemeData(color: Color(0xffe8e8e8), thickness: 1),
    dividerColor: const Color(0xffe8e8e8),

    /// Bottom AppBar Theme
    bottomAppBarTheme:
        const BottomAppBarTheme(color: Color(0xffffffff), elevation: 10),

    /// Tab bar Theme
    tabBarTheme: const TabBarTheme(
      unselectedLabelColor: Color(0xff495057),
      labelColor: Color(0xff3d63ff),
      indicatorSize: TabBarIndicatorSize.label,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: Color(0xff3d63ff), width: 2.0),
      ),
    ),

    /// CheckBox theme
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      checkColor: MaterialStateProperty.all(Colors.white),
      fillColor: MaterialStateProperty.all(const Color(0xFF808284)),
    ),

    /// Radio theme
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.all(const Color(0xff3C4EC5)),
    ),

    ///Switch Theme
    switchTheme: SwitchThemeData(
      trackColor: MaterialStateProperty.resolveWith((state) {
        const Set<MaterialState> interactiveStates = <MaterialState>{
          MaterialState.pressed,
          MaterialState.hovered,
          MaterialState.focused,
          MaterialState.selected,
        };
        if (state.any(interactiveStates.contains)) {
          return const Color(0xffabb3ea);
        }
        return null;
      }),
      thumbColor: MaterialStateProperty.resolveWith((state) {
        const Set<MaterialState> interactiveStates = <MaterialState>{
          MaterialState.pressed,
          MaterialState.hovered,
          MaterialState.focused,
          MaterialState.selected,
        };
        if (state.any(interactiveStates.contains)) {
          return const Color(0xff3C4EC5);
        }
        return null;
      }),
    ),

    // BottomNavBarTheme

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: kPrimaryColor,
      unselectedItemColor: Colors.grey,
      backgroundColor: Colors.white,
      elevation: 100,
      selectedIconTheme: IconThemeData(
        color: kPrimaryColor,
      ),
      unselectedIconTheme: IconThemeData(
        color: kSecondaryColor,
      ),
    ),

    /// Slider Theme
    sliderTheme: SliderThemeData(
      activeTrackColor: const Color(0xff3d63ff),
      inactiveTrackColor: const Color(0xFFE3E3E3),
      trackShape: const RoundedRectSliderTrackShape(),
      trackHeight: 4.0,
      thumbColor: const Color(0xff3d63ff),
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10.0),
      overlayShape: SliderComponentShape.noOverlay,
      tickMarkShape: const RoundSliderTickMarkShape(),
      inactiveTickMarkColor: Colors.red[100],
      valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
      valueIndicatorTextStyle: const TextStyle(
        color: Color(0xffeeeeee),
      ),
    ),

    /// Other Colors
    splashColor: Colors.white.withAlpha(100),
    indicatorColor: const Color(0xffeeeeee),
    highlightColor: const Color(0xffeeeeee),
    errorColor: const Color(0xfff0323c),
  );

  /// -------------------------- Dark Theme  -------------------------------------------- ///
  static final ThemeData darkTheme = ThemeData(
    /// Brightness
    brightness: Brightness.dark,

    /// Primary Color
    primaryColor: const Color(0xff26B6D7),

    textTheme: GoogleFonts.poppinsTextTheme(),

    /// Scaffold and Background color
    scaffoldBackgroundColor: const Color(0xff070C16),
    backgroundColor: const Color(0xff070C16),
    canvasColor: Colors.transparent,

    /// AppBar Theme
    appBarTheme: const AppBarTheme(backgroundColor: Color(0xff141C27)),

    /// Card Theme
    cardTheme: const CardTheme(color: Color(0xff141C27)),

    /// Colorscheme
    colorScheme: const ColorScheme.dark(
      primary: Color(0xe93a5da7),
      secondary: Color(0xffF9F7F5),
      background: Color(0xff161616),
      onPrimary: Colors.white,
      onBackground: Color(0xfff3f3f3),
      onSecondary: Color(0xff141C27),
      surface: Color(0xff585e63),
    ),

    /// Input (Text-Field) Theme
    inputDecorationTheme: const InputDecorationTheme(
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        borderSide: BorderSide(width: 1, color: Color(0xff069DEF)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        borderSide: BorderSide(width: 1, color: Colors.white70),
      ),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(width: 1, color: Colors.white70)),
    ),

    /// Divider Color
    dividerTheme:
        const DividerThemeData(color: Color(0xff363636), thickness: 1),
    dividerColor: const Color(0xff363636),

    /// Floating Action Theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: const Color(0xff069DEF),
        splashColor: Colors.white.withAlpha(100),
        highlightElevation: 8,
        elevation: 4,
        focusColor: const Color(0xff069DEF),
        hoverColor: const Color(0xff069DEF),
        foregroundColor: Colors.white),

    /// Bottom AppBar Theme
    bottomAppBarTheme:
        const BottomAppBarTheme(color: Color(0xff161616), elevation: 2),

    /// Tab bar Theme
    tabBarTheme: const TabBarTheme(
      unselectedLabelColor: Color(0xff495057),
      labelColor: Color(0xff069DEF),
      indicatorSize: TabBarIndicatorSize.label,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: Color(0xff069DEF), width: 2.0),
      ),
    ),

    ///Switch Theme
    switchTheme: SwitchThemeData(
      trackColor: MaterialStateProperty.resolveWith((state) {
        const Set<MaterialState> interactiveStates = <MaterialState>{
          MaterialState.pressed,
          MaterialState.hovered,
          MaterialState.focused,
          MaterialState.selected,
        };
        if (state.any(interactiveStates.contains)) {
          return const Color(0xffabb3ea);
        }
        return null;
      }),
      thumbColor: MaterialStateProperty.resolveWith((state) {
        const Set<MaterialState> interactiveStates = <MaterialState>{
          MaterialState.pressed,
          MaterialState.hovered,
          MaterialState.focused,
          MaterialState.selected,
        };
        if (state.any(interactiveStates.contains)) {
          return const Color(0xff3C4EC5);
        }
        return null;
      }),
    ),

    /// Slider Theme
    sliderTheme: SliderThemeData(
      activeTrackColor: const Color(0xff069DEF),
      inactiveTrackColor: const Color(0xff069DEF).withAlpha(100),
      trackShape: const RoundedRectSliderTrackShape(),
      trackHeight: 4.0,
      thumbColor: const Color(0xff069DEF),
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10.0),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 24.0),
      tickMarkShape: const RoundSliderTickMarkShape(),
      inactiveTickMarkColor: Colors.red[100],
      valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
      valueIndicatorTextStyle: const TextStyle(
        color: Colors.white,
      ),
    ),

    ///Other Color
    indicatorColor: Colors.white,
    disabledColor: const Color(0xffa3a3a3),
    highlightColor: Colors.white.withAlpha(28),
    errorColor: Colors.orange,
    cardColor: const Color(0xff282a2b),
    splashColor: Colors.white.withAlpha(56),
  );
}
