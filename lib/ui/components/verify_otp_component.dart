import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:rentx/extensions/string_extension.dart';
import 'package:rentx/size_config.dart';
import 'package:rentx/ui/base_widget.dart';
import 'package:rentx/ui/components/custom_button.dart';
import 'package:rentx/ui/components/custom_text.dart';

class VerifyOtpWidget extends StatelessWidget {
  const VerifyOtpWidget(
      {Key? key,
      this.loading,
      required this.formKey,
      required this.onSubmit,
      this.validator,
      this.email,
      this.onChanged,
      this.focusNode})
      : super(key: key);

  final GlobalKey<FormState> formKey;
  final bool? loading;
  final Function() onSubmit;
  final FormFieldValidator<String>? validator;
  final String? email;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return RentXWidget(builder: (rentXContext) {
      var pinTheme = PinTheme(
        width: width(49),
        height: height(48),
        textStyle: TextStyle(
          fontSize: width(16),
          color: rentXContext.theme.customTheme.headdline,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: rentXContext.theme.customTheme.innerBorder,
          ),
          color: rentXContext.theme.customTheme.inputFieldFill,
        ),
      );
      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image(
                  image: const AssetImage("assets/img/message.png"),
                  width: width(130),
                  height: height(130),
                ),
              ),
              SizedBox(
                height: height(30),
              ),
              CustomText(
                  align: TextAlign.center,
                  color: rentXContext.theme.customTheme.headline3,
                  textOverflow: TextOverflow.clip,
                  fontSize: width(16),
                  text: rentXContext
                      .translate('otpVerification.text')
                      .interpolate([email])),
              SizedBox(
                height: height(55),
              ),
              CustomText(
                  color: rentXContext.theme.customTheme.headdline,
                  fontSize: width(14),
                  text: "otpVerification"),
              SizedBox(
                height: height(8),
              ),
              Pinput(
                length: 6,
                pinAnimationType: PinAnimationType.scale,
                focusNode: focusNode,
                validator: validator,
                onChanged: onChanged,
                defaultPinTheme: pinTheme,
                focusedPinTheme: PinTheme(
                  width: width(49),
                  height: height(48),
                  textStyle: TextStyle(
                    fontSize: width(16),
                    color: rentXContext.theme.customTheme.headdline,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: rentXContext.theme.customTheme.primary,
                    ),
                    color: rentXContext.theme.customTheme.inputFieldFill,
                  ),
                ),
                submittedPinTheme: pinTheme,
                followingPinTheme: pinTheme,
              ),
              SizedBox(
                height: height(14),
              ),
              Center(
                child: GestureDetector(
                    onTap: () {},
                    child: CustomText(
                      color: rentXContext.theme.customTheme.primary,
                      fontSize: width(14),
                      text: "resendCode",
                    )),
              ),
              SizedBox(
                height: height(135),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(),
                  CustomButton(
                    showLoader: loading,
                    text: rentXContext.translate("confirm"),
                    radius: 6,
                    fontSize: width(16),
                    btnWidth: width(132),
                    function: onSubmit,
                    isUpperCase: false,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
