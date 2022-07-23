import 'package:flutter/material.dart';
import 'package:rentx/size_config.dart';
import 'package:rentx/theme/app_theme.dart';
import 'package:rentx/ui/base_widget.dart';

class CustomFormField extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputType? type;
  final void Function(String)? onSubmit;
  final void Function(String)? onChange;
  final void Function()? onTap;
  final bool isPassword;
  final String? Function(String?)? validate;
  final String? label;
  final int? maxLines;
  final String? hintText;
  final int? maxLength;
  final Widget? prefix;
  final bool? isAboutMe;
  final BuildContext context;
  final Widget? suffix;
  final bool isClickable;
  final bool isMapSearch;

  const CustomFormField({
    Key? key,
    required this.context,
    this.hintText,
    this.controller,
    this.isClickable = true,
    this.isPassword = false,
    this.label,
    this.maxLength,
    this.isAboutMe = false,
    this.maxLines = 1,
    this.onChange,
    this.onSubmit,
    this.onTap,
    this.prefix,
    this.suffix,
    this.type,
    this.validate,
    this.isMapSearch = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RentXWidget(
      builder: (rentxcontext) => SizedBox(
        height: isAboutMe == true ? height(102) : null,
        child: TextFormField(
          maxLength: maxLength,
          maxLines: maxLines,
          controller: controller,
          keyboardType: type,
          obscureText: isPassword,
          enabled: isClickable,
          onFieldSubmitted: onSubmit,
          onChanged: onChange,
          onTap: onTap,
          textAlign: TextAlign.left,
          textAlignVertical: TextAlignVertical.center,
          validator: validate,
          decoration: InputDecoration(
            labelText: label,
            isDense: true,
            hintText:
                hintText != null ? rentxcontext.translate(hintText!) : null,
            fillColor: rentxcontext.theme.customTheme.inputFieldFill,
            filled: true,
            errorStyle: const TextStyle(
              height: 0,
            ),
            counterText: "",
            focusColor: Colors.transparent,
            prefixIcon: prefix,
            suffixIcon: suffix,
            contentPadding: EdgeInsets.symmetric(
                horizontal: isMapSearch == true ? 0 : width(15),
                vertical: isAboutMe == false ? height(10) : height(14)),
            hintStyle: TextStyle(
              fontSize: width(14),
              color: rentxcontext.theme.customTheme.headdline,
            ),
            labelStyle: Theme.of(context).textTheme.subtitle2,
            alignLabelWithHint: false,
            floatingLabelStyle: Theme.of(context).textTheme.subtitle2!.copyWith(
                  color: AppTheme.theme.primaryColor,
                ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: rentxcontext.theme.customTheme.inputFieldBorder,
                )),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: rentxcontext.theme.customTheme.inputFieldBorder,
                )),
          ),
          style: Theme.of(context).textTheme.bodyText2,
        ),
      ),
    );
  }
}
