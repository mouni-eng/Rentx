import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rentx/models/user.dart';
import 'package:rentx/size_config.dart';
import 'package:rentx/ui/base_widget.dart';
import 'package:rentx/ui/components/custom_button.dart';
import 'package:rentx/ui/components/custom_text.dart';
import 'package:rentx/ui/screens/auth_screens/user_registration_screens/user_registration.dart';
import 'package:rentx/view_models/auth_cubit/cubit.dart';
import 'package:rentx/view_models/auth_cubit/states.dart';

class ChooseRoleScreen extends StatelessWidget {
  const ChooseRoleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: RentXWidget(
          builder: (rentxcontext) => BlocConsumer<AuthCubit, AuthStates>(
                listener: (context, state) {},
                builder: (context, state) {
                  AuthCubit cubit = AuthCubit.get(context);
                  return SafeArea(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: width(16),
                        vertical: height(16),
                      ),
                      child: Column(
                        children: [
                          CustomText(
                              color: rentxcontext.theme.customTheme.headdline,
                              fontSize: width(24),
                              fontWeight: FontWeight.w600,
                              text: "chooseYourRole"),
                          SizedBox(
                            height: height(24),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CategoryCard(
                                svgAsset: "assets/img/peoples.svg",
                                rentxcontext: rentxcontext,
                                title: "client",
                              ),
                              CategoryCard(
                                svgAsset: "assets/img/peoples.svg",
                                rentxcontext: rentxcontext,
                                title: "manager",
                              ),
                            ],
                          ),
                          const Spacer(),
                          CustomButton(
                            fontSize: width(16),
                            isUpperCase: false,
                            function: () {
                              if (cubit.category == "client") {
                                cubit.signUpRequest.role = UserRole.client;
                              } else {
                                cubit.signUpRequest.role = UserRole.manager;
                              }
                              rentxcontext.route(
                                  (p0) => const UserRegistrationScreen());
                            },
                            text: "continue",
                          ),

                        ],
                      ),
                    ),
                  );
                },
              )),
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard(
      {Key? key,
      required this.rentxcontext,
      required this.title,
      required this.svgAsset})
      : super(key: key);

  final RentXContext rentxcontext;
  final String title;
  final String svgAsset;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AuthCubit cubit = AuthCubit.get(context);
        return GestureDetector(
          onTap: () {
            cubit.onChangeCategory(title);
          },
          child: Container(
            width: width(150),
            height: height(150),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                width: 3,
                color: cubit.category == title
                    ? rentxcontext.theme.customTheme.primary
                    : rentxcontext.theme.customTheme.outerBorder,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                title == "client"
                    ? SvgPicture.asset(
                        "assets/img/people.svg",
                        width: width(38),
                        height: height(38),
                        color: cubit.category == title
                            ? rentxcontext.theme.customTheme.primary
                            : rentxcontext.theme.customTheme.headline3,
                      )
                    : SvgPicture.asset(
                        svgAsset,
                        width: width(38),
                        height: height(38),
                        color: cubit.category == title
                            ? rentxcontext.theme.customTheme.primary
                            : rentxcontext.theme.customTheme.headline3,
                      ),
                SizedBox(
                  height: height(10),
                ),
                CustomText(
                  color: cubit.category == title
                      ? rentxcontext.theme.customTheme.primary
                      : rentxcontext.theme.customTheme.headline3,
                  fontSize: width(16),
                  fontWeight: FontWeight.w600,
                  text: title,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
