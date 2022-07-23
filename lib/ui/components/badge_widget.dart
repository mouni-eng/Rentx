import 'package:flutter/material.dart';
import 'package:rentx/size_config.dart';

import 'custom_text.dart';

class CustomRectBadge extends StatelessWidget {
  const CustomRectBadge({
    Key? key,
    required this.text,
    required this.color,
    required this.bgColor,
    this.badgeWidth,
  }) : super(key: key);

  final String text;
  final Color color;
  final Color bgColor;
  final double? badgeWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width(badgeWidth ?? 82),
      height: height(30),
      padding: EdgeInsets.symmetric(
        horizontal: width(12),
        vertical: height(6),
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Center(
        child: CustomText(
          color: color,
          fontSize: width(12),
          text: text,
          fontWeight: FontWeight.w600,
          align: TextAlign.center,
        ),
      ),
    );
  }
}
