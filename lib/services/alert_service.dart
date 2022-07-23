import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rentx/constants.dart';
import 'package:rentx/infrastructure/exceptions.dart';
import 'package:rentx/size_config.dart';
import 'package:rentx/ui/base_widget.dart';
import 'package:rentx/ui/components/custom_text.dart';

enum SnackbarType { success, warning, error }

class ErrorService {
  static String defineError(error) {
    if (error is ApiException) {
      return error.errorCode;
    } else if (error is String) {
      return error;
    }
    return '';
  }
}

class AlertService {
  static showSnackbarAlert(
      String strAlert, RentXContext rentXContext, SnackbarType type) {
    Flushbar(
      padding: EdgeInsets.symmetric(
        horizontal: width(16),
        vertical: height(16),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: width(16),
        vertical: height(16),
      ),
      boxShadows: [boxShadow],
      borderRadius: BorderRadius.circular(16),
      backgroundColor: rentXContext.theme.customTheme.onPrimary,
      titleText: type.index == 2
          ? CustomText(
              color: rentXContext.theme.customTheme.headdline,
              fontSize: width(16),
              text: '$strAlert.code',
              fontWeight: FontWeight.w600,
            )
          : CustomText(
              color: rentXContext.theme.customTheme.headdline,
              fontSize: width(16),
              text: type.name,
              fontWeight: FontWeight.w600,
            ),
      messageText: CustomText(
        color: rentXContext.theme.customTheme.headline3,
        fontSize: width(14),
        maxlines: 3,
        text: '$strAlert.desc',
      ),
      icon: SvgPicture.asset("assets/img/${type.name}.svg"),
      mainButton: GestureDetector(
        onTap: () {
          rentXContext.pop();
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width(16),
          ),
          child: SvgPicture.asset("assets/img/exit.svg"),
        ),
      ),
    ).show(rentXContext.context);
  }
}
