import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rentx/size_config.dart';
import 'package:rentx/ui/base_widget.dart';
import 'package:rentx/ui/components/custom_button.dart';
import 'package:rentx/ui/components/custom_text.dart';

class CompletedScreen extends StatelessWidget {
  const CompletedScreen(
      {Key? key,
      required this.text,
      required this.onBtnClick,
      this.btnText = 'done',
      this.title})
      : super(key: key);

  final String? title;
  final String text;
  final String? btnText;
  final Function()? onBtnClick;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RentXWidget(
        builder: (rentXContext) => Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width(16),
            vertical: height(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: height(220),
              ),
              SvgPicture.asset("assets/img/done.svg"),
              SizedBox(
                height: height(16),
              ),
              if (title != null)
                CustomText(
                  color: rentXContext.theme.customTheme.headdline,
                  fontSize: width(18),
                  fontWeight: FontWeight.w600,
                  text: rentXContext.translate(title!),
                  align: TextAlign.center,
                  textOverflow: TextOverflow.clip,
                ),
              if (title != null)
                SizedBox(
                  height: height(6),
                ),
              CustomText(
                color: rentXContext.theme.customTheme.secondary,
                fontSize: width(18),
                text: rentXContext.translate(text),
                align: TextAlign.center,
                textOverflow: TextOverflow.clip,
              ),
              const Spacer(),
              CustomButton(
                fontSize: width(16),
                isUpperCase: false,
                function: onBtnClick,
                text: rentXContext.translate(btnText!),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
