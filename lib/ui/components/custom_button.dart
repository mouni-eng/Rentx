import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rentx/size_config.dart';
import 'package:rentx/ui/base_widget.dart';
import 'package:rentx/ui/components/custom_text.dart';

class CustomButton extends StatelessWidget {
  final double? btnWidth;
  final double? btnHeight;
  final Color? background;
  final bool? isUpperCase;
  final double? radius;
  final double? fontSize;
  final Function()? function;
  final String? text;
  final String? svgLeadingIcon;
  final bool? showLoader;
  final bool? enabled;

  const CustomButton({
    Key? key,
    this.btnWidth = double.infinity,
    this.background,
    this.radius = 6.0,
    required this.fontSize,
    this.isUpperCase = false,
    required this.function,
    required this.text,
    this.svgLeadingIcon,
    this.showLoader = false,
    this.btnHeight = 48,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RentXWidget(builder: (rentxcontext) {
      var bgColor = background ?? rentxcontext.theme.customTheme.primary;
      return Container(
        width: btnWidth,
        height: btnHeight,
        child: MaterialButton(
            onPressed: showLoader! || !enabled! ? null : function,
            child: _rowWidget(rentxcontext)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            radius!,
          ),
          color: showLoader! || !enabled! ? bgColor.withOpacity(0.3) : bgColor,
        ),
      );
    });
  }

  Widget _rowWidget(RentXContext rentXContext) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (svgLeadingIcon != null)
          SvgPicture.asset(
            svgLeadingIcon!,
            color: rentXContext.theme.customTheme.onPrimary,
          ),
        if (svgLeadingIcon != null)
          SizedBox(
            width: width(14),
          ),
        if (showLoader!)
          SizedBox(
              width: height(btnHeight! * 0.7),
              height: height(btnHeight! * 0.7),
              child: CircularProgressIndicator.adaptive(
                backgroundColor: rentXContext.theme.customTheme.onPrimary,
              )),
        if (showLoader!)
          SizedBox(
            width: width(14),
          ),
        _textWidget(rentXContext)
      ],
    );
  }

  Widget _textWidget(RentXContext rentXContext) {
    return Expanded(
        child: Center(
      child: CustomText(
        text: isUpperCase! ? text!.toUpperCase() : text!,
        color: rentXContext.theme.customTheme.onPrimary,
        fontWeight: FontWeight.w600,
        fontSize: fontSize!,
      ),
    ));
  }
}
