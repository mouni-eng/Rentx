import 'package:flutter/material.dart';
import 'package:rentx/size_config.dart';
import 'package:rentx/ui/base_widget.dart';
import 'package:rentx/ui/components/custom_text.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    Key? key,
    required this.title,
    this.fontWeight = FontWeight.w600,
    this.onTap,
    this.rawText,
    this.btnText,
  }) : super(key: key);

  final String title;
  final String? rawText;
  final FontWeight fontWeight;
  final String? btnText;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return RentXWidget(
      builder: (rentxcontext) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            color: rentxcontext.theme.customTheme.secondary,
            fontSize: width(16),
            fontWeight: fontWeight,
            text: rentxcontext.translate(title) + (rawText ?? ''),
          ),
          GestureDetector(
            onTap: onTap,
            child: CustomText(
              color: const Color(0xFF828282),
              fontSize: width(14),
              textDecoration: TextDecoration.underline,
              text: rentxcontext.translate(btnText ?? 'viewAll'),
            ),
          ),
        ],
      ),
    );
  }
}
