import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rentx/size_config.dart';
import 'package:rentx/ui/base_widget.dart';
import 'package:rentx/ui/components/custom_button.dart';
import 'package:rentx/ui/components/custom_text.dart';
import 'package:rentx/ui/components/rentx_imagepicker.dart';
import 'package:rentx/ui/screens/car_listing_screens/create/steps/set_properties.dart';
import 'package:rentx/view_models/auth_cubit/cubit.dart';
import 'package:rentx/view_models/auth_cubit/states.dart';

class PersonalDataScreen extends StatelessWidget {
  const PersonalDataScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RentXWidget(
      builder: (rentxcontext) => BlocConsumer<AuthCubit, AuthStates>(
        listener: (context, state) {},
        builder: (context, state) {
          AuthCubit cubit = AuthCubit.get(context);
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: cubit.formKey1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: ProfilePictureWidget(
                      profileImage: cubit.profileImage,
                      onPickImage: cubit.chooseImage,
                      profileImageUrl: "",
                    ),
                  ),
                  SizedBox(
                    height: height(16),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                          color: rentxcontext.theme.customTheme.headdline,
                          fontSize: width(18),
                          fontWeight: FontWeight.w600,
                          text: cubit.name ?? "createProfile"),
                      CustomText(
                          color: rentxcontext.theme.customTheme.headdline,
                          fontSize: width(18),
                          fontWeight: FontWeight.w600,
                          text: cubit.surName != null ? cubit.surName! : ""),
                    ],
                  ),
                  SizedBox(
                    height: height(2),
                  ),
                  Center(
                    child: CustomText(
                        color: rentxcontext.theme.customTheme.headline2,
                        fontSize: width(16),
                        text: cubit.category!),
                  ),
                  SizedBox(
                    height: height(21),
                  ),
                  PropertiesWidget(
                      name: "name",
                      onChange: (value) {
                        cubit.onChangeName(value);
                      }),
                  PropertiesWidget(
                      name: "surname",
                      onChange: (value) {
                        cubit.onChangeSurName(value);
                      }),
                  PropertiesWidget(
                      name: "phoneNumber",
                      isPhoneNumber: true,
                      onChange: (value) {
                        cubit.onChangePhoneNumber(value);
                      }),
                  CustomText(
                    color: rentxcontext.theme.customTheme.headdline,
                    fontSize: width(14),
                    text: "birthDate",
                  ),
                  SizedBox(
                    height: height(5),
                  ),
                  CustomDatePicker(
                    birthdate: cubit.birthDate,
                    onChange: cubit.onChangeBirthDate,
                  ),
                  SizedBox(
                    height: height(30),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (cubit.index != 0)
                        TextButton(
                            onPressed: () {
                              cubit.onBackStep();
                            },
                            child: Text(
                              rentxcontext.translate("back"),
                              style: TextStyle(
                                fontSize: width(16),
                                color: rentxcontext.theme.customTheme.headdline,
                              ),
                            )),
                      if (cubit.index == 0) Container(),
                      CustomButton(
                        showLoader: state is RegisterLoadingState,
                        text: rentxcontext
                            .translate('next'),
                        radius: 6,
                        fontSize: width(16),
                        btnWidth: width(132),
                        function: () {
                          cubit.onNextValidation(context);
                        },
                        isUpperCase: false,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class CustomDatePicker extends StatelessWidget {
  const CustomDatePicker({
    Key? key,
    this.birthdate,
    required this.onChange,
  }) : super(key: key);

  final DateTime? birthdate;
  final dynamic Function(DateTime) onChange;

  @override
  Widget build(BuildContext context) {
    return RentXWidget(
      builder: (rentxcontext) => GestureDetector(
        onTap: () {
          showDatePicker(
                  context: context,
                  initialDate: birthdate != null ? birthdate! : DateTime.now(),
                  firstDate: DateTime(2022, 4),
                  lastDate: DateTime(DateTime.now().year + 10))
              .then((value) {
            onChange(value!);
          });
        },
        child: Container(
          width: double.infinity,
          height: height(47),
          padding:
              EdgeInsets.symmetric(horizontal: width(15), vertical: height(10)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: rentxcontext.theme.customTheme.inputFieldBorder,
            ),
            color: rentxcontext.theme.customTheme.inputFieldFill,
          ),
          child: CustomText(
              fontSize: width(14),
              color: rentxcontext.theme.customTheme.headdline,
              text: birthdate != null
                  ? birthdate!.toString().split(" ").toList()[0]
                  : "enterHere"),
        ),
      ),
    );
  }
}

class ProfilePictureWidget extends StatelessWidget {
  const ProfilePictureWidget({
    Key? key,
    this.profileImage,
    required this.onPickImage,
    required this.profileImageUrl,
  }) : super(key: key);

  final File? profileImage;

  final String? profileImageUrl;

  final Function(File) onPickImage;

  @override
  Widget build(BuildContext context) {
    return RentXWidget(
      builder: (rentxcontext) => RentXImagePicker(
          widgetBuilder: () => SizedBox(
                height: height(100),
                width: width(101),
                child: Stack(
                  children: [
                    Container(
                      width: width(90),
                      height: height(90),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: rentxcontext.theme.customTheme.headline3),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: profileImage != null
                              ? Image(
                                  image: FileImage(profileImage!),
                                  fit: BoxFit.cover,
                                )
                              : CheckImageAvailable(
                                  profileImageUrl: profileImageUrl,
                                )),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: width(34),
                        height: height(34),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: rentxcontext.theme.customTheme.primary,
                        ),
                        child: SvgPicture.asset(
                          "assets/img/pick.svg",
                          width: width(18),
                          height: height(18),
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          onFilePick: onPickImage),
    );
  }
}

class CheckImageAvailable extends StatelessWidget {
  const CheckImageAvailable({Key? key, required this.profileImageUrl})
      : super(key: key);

  final String? profileImageUrl;

  @override
  Widget build(BuildContext context) {
    return profileImageUrl == null || profileImageUrl!.isEmpty
        ? Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width(15),
              vertical: height(15),
            ),
            child: SvgPicture.asset(
              "assets/img/people.svg",
            ))
        : CachedNetworkImage(
            imageUrl: profileImageUrl!,
            fit: BoxFit.cover,
          );
  }
}
