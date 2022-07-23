import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rentx/services/alert_service.dart';
import 'package:rentx/size_config.dart';
import 'package:rentx/ui/base_widget.dart';
import 'package:rentx/ui/components/custom_button.dart';
import 'package:rentx/ui/components/custom_text.dart';
import 'package:rentx/ui/screens/auth_screens/user_registration_screens/choose_role_screen.dart';
import 'package:rentx/ui/screens/car_listing_screens/create/steps/set_properties.dart';
import 'package:rentx/ui/screens/password_reset/passwod_reset_screen.dart';
import 'package:rentx/view_models/login_cubit/cubit.dart';
import 'package:rentx/view_models/login_cubit/states.dart';

class LogInScreen extends StatelessWidget {
  LogInScreen({Key? key, this.postLoginOperation}) : super(key: key);
  final formKey = GlobalKey<FormState>();

  final Function()? postLoginOperation;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return RentXWidget(
      builder: (rentxcontext) => BlocConsumer<LogInCubit, LogInStates>(
        builder: (context, state) {
          LogInCubit cubit = LogInCubit.get(context);
          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: width(24),
                    vertical: height(24),
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Image.asset(
                            "assets/img/login.png",
                            width: width(235),
                            height: height(165),
                          ),
                        ),
                        SizedBox(
                          height: height(18),
                        ),
                        CustomText(
                          color: rentxcontext.theme.customTheme.headdline,
                          fontSize: width(28),
                          text: "login",
                          fontWeight: FontWeight.w600,
                        ),
                        CustomText(
                          color: rentxcontext.theme.customTheme.headline3,
                          fontSize: width(14),
                          text: "loginWelcome",
                          fontWeight: FontWeight.w400,
                        ),
                        SizedBox(
                          height: height(28),
                        ),
                        PropertiesWidget(
                          name: "username",
                          onChange: (value) {
                            cubit.chooseUserName(value);
                          },
                        ),
                        PropertiesWidget(
                          name: "password",
                          onChange: (value) {
                            cubit.choosePassword(value);
                          },
                          isPassword: true,
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: () {
                              rentxcontext.route(
                                  (context) => const PasswordResetScreen());
                            },
                            child: CustomText(
                              color: rentxcontext.theme.customTheme.primary,
                              fontSize: width(14),
                              text: "forgotPassword?",
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height(24),
                        ),
                        CustomButton(
                          showLoader: state is LogInLoadingState,
                          fontSize: width(16),
                          isUpperCase: false,
                          function: () {
                            if (formKey.currentState!.validate()) {
                              cubit.logIn(rentxcontext);
                            }
                          },
                          text: "logIn",
                        ),
                        SizedBox(
                          height: height(35),
                        ),
                        Row(
                          children: [
                            const Expanded(
                              child: Divider(
                                thickness: 1,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: width(12),
                              ),
                              child: CustomText(
                                color: rentxcontext.theme.customTheme.headline3,
                                fontSize: width(14),
                                text: "or Sign in with",
                              ),
                            ),
                            const Expanded(
                              child: Divider(
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height(22),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                cubit.googleSignIn(rentxcontext);
                              },
                              child: Container(
                                width: width(52),
                                height: height(52),
                                padding: EdgeInsets.symmetric(
                                  horizontal: width(10),
                                  vertical: height(10),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: rentxcontext
                                      .theme.customTheme.profileFill,
                                ),
                                child: SvgPicture.asset(
                                  "assets/img/Google.svg",
                                ),
                              ),
                            ),
                            SizedBox(
                              width: width(16),
                            ),
                            GestureDetector(
                              onTap: () {
                                cubit.facebookSignIn(rentxcontext);
                              },
                              child: Container(
                                width: width(52),
                                height: height(52),
                                padding: EdgeInsets.symmetric(
                                  horizontal: width(10),
                                  vertical: height(10),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: rentxcontext
                                      .theme.customTheme.profileFill,
                                ),
                                child: SvgPicture.asset(
                                  "assets/img/Facebook.svg",
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height(24),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              color: rentxcontext.theme.customTheme.headline2,
                              fontSize: width(14),
                              text: "dontHaveAnAccount",
                            ),
                            GestureDetector(
                              onTap: () {
                                rentxcontext
                                    .route((p0) => const ChooseRoleScreen());
                              },
                              child: CustomText(
                                color: rentxcontext.theme.customTheme.primary,
                                fontSize: width(14),
                                text: " registerNow",
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        listener: (context, state) {
          if (state is LogInErrorState) {
            AlertService.showSnackbarAlert(
                state.error!, rentxcontext, SnackbarType.error);
          }
        },
      ),
    );
  }
}
