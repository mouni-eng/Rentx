import 'package:flutter/material.dart';

class CustomTheme {
  static const Color occur = Color(0xffb38220);
  static const Color peach = Color(0xffe09c5f);
  static const Color skyBlue = Color(0xff639fdc);
  static const Color darkGreen = Color(0xff226e79);
  static const Color red = Color(0xfff8575e);
  static const Color purple = Color(0xff9f50bf);
  static const Color pink = Color(0xffd17b88);
  static const Color brown = Color(0xffbd631a);
  static const Color blue = Color(0xff1a71bd);
  static const Color green = Color(0xff068425);
  static const Color yellow = Color(0xfffff44f);
  static const Color orange = Color(0xffFFA500);

  final Color card,
      cardDark,
      border,
      borderDark,
      disabledColor,
      onDisabled,
      colorInfo,
      colorWarning,
      colorSuccess,
      colorError,
      shadowColor,
      onInfo,
      onWarning,
      onSuccess,
      onError,
      shimmerBaseColor,
      shimmerHighlightColor,
      textColor,
      iconColor;

  final Color primary,
      onPrimary,
      secondary,
      onSecondary,
      kSecondaryColor,
      kSecondaryColorBold,
      headdline,
      headline2,
      headline3,
      headline4,
      inputFieldBorder,
      inputFieldFill,
      inputFieldFillBold,
      innerBorder,
      profileFill,
      pending,
      approve,
      rejected,
      onPending,
      onApprove,
      onRejected,
      outerBorder;

  CustomTheme(
      {this.border = const Color(0xffE0E0E0),
      this.borderDark = const Color(0xffe6e6e6),
      this.card = const Color(0xffEEF2FA),
      this.cardDark = const Color(0xffE5EDFA),
      this.disabledColor = const Color(0xff6F737B),
      this.onDisabled = const Color(0xffffffff),
      this.colorWarning = const Color(0xffffc837),
      this.colorInfo = const Color(0xffff784b),
      this.colorSuccess = const Color(0xff3cd278),
      this.shadowColor = const Color(0xff1f1f1f),
      this.onInfo = const Color(0xffffffff),
      this.onWarning = const Color(0xffffffff),
      this.onSuccess = const Color(0xffffffff),
      this.colorError = const Color(0xfff0323c),
      this.onError = const Color(0xffffffff),
      this.shimmerBaseColor = const Color(0xFFF5F5F5),
      this.shimmerHighlightColor = const Color(0xFFE0E0E0),
      this.primary = const Color(0xff2E70E2),
      this.onPrimary = const Color(0xffffffff),
      this.secondary = const Color(0xff2E70E2),
      this.onSecondary = const Color(0xff21262E),
      this.kSecondaryColor = const Color(0xFF9EA7B2),
      this.headdline = const Color(0xFF333333),
      this.headline2 = const Color(0xFF4F4F4F),
      this.headline3 = const Color(0xFF828282),
      this.headline4 = const Color(0xFFE0E0E0),
      this.inputFieldFill = const Color(0xFFF9F9FB),
      this.inputFieldBorder = const Color(0xFFEFEFEF),
      this.outerBorder = const Color(0xFFE0E0E0),
      this.innerBorder = const Color(0xFFF2F2F2),
      this.profileFill = const Color(0xff0f007bff),
      this.pending = const Color(0xff29f2c94c),
      this.approve = const Color(0xFFDCF2E5),
      this.rejected = const Color(0xFFFCE4E4),
      this.onPending = const Color(0xFFD8AB22),
      this.onApprove = const Color(0xFF219653),
      this.onRejected = const Color(0xFFEB5757),
      this.textColor = const Color(0xffe6e6e6),
      this.kSecondaryColorBold = const Color(0xFF616A80),
      this.inputFieldFillBold = const Color(0xFFBDBDBD),
      this.iconColor = const Color(0xff2E70E2)});

  //--------------------------------------  Custom App Theme ----------------------------------------//

  static final CustomTheme lightCustomTheme = CustomTheme(
      card: const Color(0xFBE1FBFF),
      cardDark: const Color(0xfffdfdfd),
      disabledColor: const Color(0xff6F737B),
      onDisabled: const Color(0xffffffff),
      colorInfo: const Color(0xffff784b),
      colorWarning: const Color(0xffffc837),
      colorSuccess: const Color(0xff3cd278),
      shadowColor: const Color(0xffd9d9d9),
      onInfo: const Color(0xffffffff),
      onSuccess: const Color(0xffffffff),
      onWarning: const Color(0xffffffff),
      colorError: const Color(0xfff0323c),
      onError: const Color(0xffffffff),
      shimmerBaseColor: const Color(0xFFF5F5F5),
      textColor: const Color(0xff000000),
      shimmerHighlightColor: const Color(0xFFE0E0E0),
      primary: const Color(0xff2E70E2),
      onPrimary: const Color(0xffffffff),
      secondary: const Color(0xff21262E),
      onSecondary: const Color(0xFFE0E0E0),
      kSecondaryColor: const Color(0xFF9EA7B2),
      headdline: const Color(0xFF333333),
      headline2: const Color(0xFF4F4F4F),
      headline3: const Color(0xFF828282),
      iconColor: const Color(0xff2E70E2));

  static final CustomTheme darkCustomTheme = CustomTheme(
      card: const Color(0xff141C27),
      cardDark: const Color(0xff262F42),
      border: const Color(0xff141C27),
      borderDark: const Color(0xff363636),
      disabledColor: const Color(0xff6F737B),
      onDisabled: const Color(0xff000000),
      colorInfo: const Color(0xffff784b),
      colorWarning: const Color(0xffffc837),
      colorSuccess: const Color(0xff3cd278),
      shadowColor: const Color(0xff202020),
      onInfo: const Color(0xffffffff),
      onSuccess: const Color(0xffffffff),
      onWarning: const Color(0xffffffff),
      colorError: const Color(0xfff0323c),
      onError: const Color(0xffffffff),
      shimmerBaseColor: const Color(0xFF1a1a1a),
      textColor: const Color(0xffffffff),
      shimmerHighlightColor: const Color(0xFF454545),
      primary: const Color(0xff226e79),
      onPrimary: const Color(0xffffffff),
      secondary: const Color(0xff226e79),
      onSecondary: const Color(0xffffffff),
      kSecondaryColor: Colors.white,
      headdline: Colors.white,
      headline2: Colors.white,
      headline3: Colors.white,
      iconColor: const Color(0xff26B6D7));
}
