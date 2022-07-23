import 'package:flutter/material.dart';
import 'package:rentx/infrastructure/localizations/translator.dart';
import 'package:rentx/models/user.dart';
import 'package:rentx/services/auth_service.dart';
import 'package:rentx/theme/app_theme.dart';
import 'package:rentx/theme/theme_type.dart';
import 'package:rentx/ui/screens/auth_screens/logIn_screen.dart';

enum DeviceScreenType { mobile, tablet, desktop }

class RentXContext {
  final RentXSizeInfo size;
  final BuildContext context;
  final RentXTheme theme;

  String translate(String key) {
    return Translator.translate(key);
  }

  RentXContext(
      {required this.size, required this.context, required this.theme});

  Future<dynamic> route(
      Widget Function(BuildContext context) routeSupplier) async {
    return Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => routeSupplier.call(context)));
  }

  Future<dynamic> authenticatedRoute(
      Widget? Function(
              BuildContext context, bool isLoggedIn, UserRole? userRole)
          routeSupplier) async {
    Widget? screen = routeSupplier.call(
        context, AuthService.isLoggedIn, AuthService.loggedUserRole);
    if (screen != null) {
      return await route((p0) => screen);
    }
    return null;
  }

  Future<dynamic> authenticatedAction(
      dynamic Function(
              BuildContext context, bool isLoggedIn, UserRole? userRole)
          action) async {
    return action.call(
        context, AuthService.isLoggedIn, AuthService.loggedUserRole);
  }

  Future<bool> requireAuth(Function() caller) async {
    if (AuthService.isLoggedIn) {
      caller.call();
      return true;
    } else {
      await route((p0) => LogInScreen(
            postLoginOperation: caller,
          ));
      return false;
    }
  }

  void pop() {
    Navigator.of(context).pop();
  }
}

class RentXSizeInfo {
  final Orientation orientation;
  final DeviceScreenType screenType;
  final Size screenSize;
  final Size localWidgetSize;

  double scaleScreenHeight(double scale) {
    return screenSize.height * scale;
  }

  double scaleScreenHeightOrMin(double scale, double min) {
    double scaled = screenSize.height * scale;
    return scaled > min ? scaled : min;
  }

  double scaleScreenHeightOrMax(double scale, double max) {
    double scaled = screenSize.height * scale;
    return scaled > max ? max : scaled;
  }

  double scaleScreenWidth(double scale) {
    return screenSize.width * scale;
  }

  double scaleScreenWidthOrMin(double scale, double min) {
    double scaled = screenSize.width * scale;
    return scaled > min ? scaled : min;
  }

  double scaleWidgetHeight(double scale) {
    return localWidgetSize.height * scale;
  }

  double scaleWidgetWidth(double scale) {
    return localWidgetSize.width * scale;
  }

  double deviceWidth(
      {required double mobile,
      required double tablet,
      required double desktop}) {
    if (screenType == DeviceScreenType.mobile) {
      return screenSize.width * mobile;
    }
    if (screenType == DeviceScreenType.tablet) {
      return screenSize.width * tablet;
    }
    return screenSize.width * desktop;
  }

  RentXSizeInfo(
      {required this.orientation,
      required this.screenType,
      required this.screenSize,
      required this.localWidgetSize});
}

class RentXTheme {
  final CustomTheme customTheme;
  final ThemeData theme;
  final ThemeType themeType;

  RentXTheme(
      {required this.customTheme,
      required this.theme,
      required this.themeType});
}

class RentXWidget extends StatelessWidget {
  final Widget Function(RentXContext rentXContext) builder;

  const RentXWidget({Key? key, required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final mediaQuery = MediaQuery.of(context);
      late ThemeData theme = AppTheme.theme;
      late CustomTheme customTheme = AppTheme.customTheme;
      var sizingInfo = RentXSizeInfo(
          orientation: mediaQuery.orientation,
          screenType: _getDeviceType(mediaQuery),
          screenSize: mediaQuery.size,
          localWidgetSize: Size(constraints.maxWidth, constraints.maxHeight));
      var themeInfo = RentXTheme(
          customTheme: customTheme,
          theme: theme,
          themeType: AppTheme.themeType);
      var rentXContext =
          RentXContext(size: sizingInfo, context: context, theme: themeInfo);
      return builder(rentXContext);
    });
  }

  DeviceScreenType _getDeviceType(MediaQueryData mediaQueryData) {
    double deviceWidth = 0;
    if (mediaQueryData.orientation == Orientation.landscape) {
      deviceWidth = mediaQueryData.size.height;
    } else {
      deviceWidth = mediaQueryData.size.width;
    }
    if (deviceWidth > 950) {
      return DeviceScreenType.desktop;
    }
    if (deviceWidth > 600) {
      return DeviceScreenType.tablet;
    }
    return DeviceScreenType.mobile;
  }
}

class RentXAuthenticatedWidget extends StatelessWidget {
  const RentXAuthenticatedWidget(
      {Key? key,
      required this.predicate,
      required this.builder,
      required this.fallback})
      : super(key: key);

  final bool Function(UserRole? role, bool authenticated) predicate;
  final Widget Function(RentXContext rentXContext) builder;
  final Widget Function(RentXContext rentXContext) fallback;

  @override
  Widget build(BuildContext context) {
    return RentXWidget(
        builder:
            predicate.call(AuthService.loggedUserRole, AuthService.isLoggedIn)
                ? builder
                : fallback);
  }
}
