import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rentx/helper/validation.dart';
import 'package:rentx/size_config.dart';
import 'package:rentx/ui/base_widget.dart';
import 'package:rentx/ui/components/custom_button.dart';
import 'package:rentx/ui/components/custom_text.dart';
import 'package:rentx/ui/components/rentx_imagepicker.dart';
import 'package:rentx/ui/screens/car_listing_screens/create/steps/set_properties.dart';
import 'package:rentx/view_models/company_auth_cubit/cubit.dart';
import 'package:rentx/view_models/company_auth_cubit/states.dart';

class CompanyData extends StatelessWidget {
  const CompanyData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RentXWidget(
        builder: (rentxcontext) => BlocConsumer<CompanyAuthCubit,
                CompanyAuthStates>(
            builder: (context, state) {
              CompanyAuthCubit cubit = CompanyAuthCubit.get(context);
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: width(24),
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Form(
                    key: cubit.formKey4,
                    child: Column(
                      children: [
                        SizedBox(
                          height: height(190.0),
                          child: Stack(
                            alignment: AlignmentDirectional.bottomCenter,
                            children: [
                              RentXImagePicker(
                                  widgetBuilder: () => Stack(
                                        children: [
                                          Align(
                                            child: cubit.headerImage == null
                                                ? Container(
                                                    height: height(146.5),
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                      color: rentxcontext
                                                          .theme
                                                          .customTheme
                                                          .headline4,
                                                    ),
                                                  )
                                                : Container(
                                                    height: height(146.5),
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                      color: rentxcontext
                                                          .theme
                                                          .customTheme
                                                          .headline4,
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                      child: Image(
                                                        image: FileImage(
                                                            cubit.headerImage!),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                            alignment:
                                                AlignmentDirectional.topCenter,
                                          ),
                                          Positioned(
                                            top: 8,
                                            right: 8,
                                            child: Container(
                                              width: width(34),
                                              height: height(34),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: rentxcontext.theme
                                                    .customTheme.onPrimary,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color:
                                                        const Color(0xFF000000)
                                                            .withOpacity(0.2),
                                                    //color of shadow
                                                    //spread radius
                                                    blurRadius: width(30),
                                                    // blur radius
                                                    offset: const Offset(0, 4),
                                                  ),
                                                ],
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: width(8),
                                                  vertical: height(9),
                                                ),
                                                child: SvgPicture.asset(
                                                  "assets/img/camera.svg",
                                                  color: rentxcontext.theme
                                                      .customTheme.primary,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                  onFilePick: cubit.chooseBannerImage),
                              RentXImagePicker(
                                  widgetBuilder: () => Stack(
                                        children: [
                                          CircleAvatar(
                                            radius: width(65),
                                            backgroundColor: rentxcontext
                                                .theme.customTheme.onPrimary,
                                            child: cubit.logoImage == null
                                                ? CircleAvatar(
                                                    radius: width(62),
                                                    backgroundColor:
                                                        rentxcontext
                                                            .theme
                                                            .customTheme
                                                            .headline4,
                                                    child: Center(
                                                      child: CustomText(
                                                          color: rentxcontext
                                                              .theme
                                                              .customTheme
                                                              .headline3,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          fontSize: width(20),
                                                          text: "LOGO"),
                                                    ),
                                                  )
                                                : CircleAvatar(
                                                    radius: width(62),
                                                    backgroundColor:
                                                        rentxcontext
                                                            .theme
                                                            .customTheme
                                                            .headline4,
                                                    backgroundImage: FileImage(
                                                        cubit.logoImage!),
                                                  ),
                                          ),
                                          Positioned(
                                            bottom: 4,
                                            right: 5,
                                            child: Container(
                                              width: width(34),
                                              height: height(34),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: rentxcontext.theme
                                                    .customTheme.onPrimary,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color:
                                                        const Color(0xFF000000)
                                                            .withOpacity(0.2),
                                                    //color of shadow
                                                    //spread radius
                                                    blurRadius: width(30),
                                                    // blur radius
                                                    offset: const Offset(0, 4),
                                                  ),
                                                ],
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: width(8),
                                                  vertical: height(9),
                                                ),
                                                child: SvgPicture.asset(
                                                  "assets/img/camera.svg",
                                                  color: rentxcontext.theme
                                                      .customTheme.primary,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                  onFilePick: cubit.chooseLogoImage),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height(34),
                        ),
                        PropertiesWidget(
                          name: "Name",
                          isMaxChar: true,
                          validate: (value) {
                            if (value!.isEmpty || value.length > 20) {
                              return "";
                            }
                            return null;
                          },
                          onChange: (value) {
                            cubit.onChangeCompanyName(value);
                          },
                        ),
                        PropertiesWidget(
                          name: "Description",
                          isDiscription: true,
                          onChange: (value) {
                            cubit.onChangeCompanyDescription(value);
                          },
                        ),
                        PropertiesWidget(
                          name: "Company Email Address",
                          validate: (value) => Validators.validateEmail(value),
                          onChange: (value) {
                            cubit.onChangeCompanyEmail(value);
                          },
                        ),
                        PropertiesWidget(
                          name: "Company Phone Number",
                          isPhoneNumber: true,
                          onChange: (value) {
                            cubit.onChangeCompanyPhone(value);
                          },
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: CustomButton(
                            text: rentxcontext.translate("Next"),
                            radius: 6,
                            fontSize: width(16),
                            btnWidth: width(132),
                            function: () {
                              if (cubit.formKey4.currentState!.validate()) {
                                cubit.onNextStepCompany();
                              }
                            },
                            isUpperCase: false,
                          ),
                        ),
                        SizedBox(
                          height: height(20),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            listener: (context, state) {}));
  }
}
