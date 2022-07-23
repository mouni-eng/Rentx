import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentx/size_config.dart';
import 'package:rentx/ui/base_widget.dart';
import 'package:rentx/ui/components/custom_button.dart';
import 'package:rentx/ui/components/custom_text.dart';
import 'package:rentx/ui/screens/car_listing_screens/create/steps/set_properties.dart';
import 'package:rentx/view_models/auth_cubit/cubit.dart';
import 'package:rentx/view_models/auth_cubit/states.dart';

class AccountDataScreen extends StatelessWidget {
  const AccountDataScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RentXWidget(
      builder: (rentxcontext) =>
          BlocConsumer<AuthCubit, AuthStates>(builder: (context, state) {
        AuthCubit cubit = AuthCubit.get(context);
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: cubit.formKey2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PropertiesWidget(
                    name: "username",
                    validate: (val) => cubit.usernameValidation,
                    onChange: (value) {
                      cubit.onChangeUserName(value);
                    }),
                PropertiesWidget(
                    name: "Email Address",
                    validate: (val) => cubit.emailValidation,
                    onChange: (value) {
                      cubit.onChangeEmailAddress(value);
                    }),
                PropertiesWidget(
                    name: "password",
                    isPassword: true,
                    onChange: (value) {
                      cubit.onChangePassword(value);
                    }),
                PropertiesWidget(
                    isPassword: true,
                    name: "confirmPassword",
                    onChange: (value) {
                      cubit.onChangeConfirmPassword(value);
                    }),
                if (cubit.password != cubit.confirmPassword)
                  CustomText(
                    color: rentxcontext.theme.customTheme.onRejected,
                    fontSize: width(12),
                    text: rentxcontext.translate("passwordsDontMatch"),
                  ),
                SizedBox(
                  height: height(115),
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
                            rentxcontext.translate("Back"),
                            style: TextStyle(
                              fontSize: width(16),
                              color: rentxcontext.theme.customTheme.headdline,
                            ),
                          )),
                    if (cubit.index == 0) Container(),
                    CustomButton(
                      showLoader: state is RegisterLoadingState,
                      text: rentxcontext.translate("next"),
                      radius: 6,
                      fontSize: width(16),
                      btnWidth: width(132),
                      function: () {
                        cubit.onNextValidation(context);
                      },
                      isUpperCase: false,
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      }, listener: (context, state) {
        AuthCubit.get(context).formKey2.currentState!.validate();
        if (state is RegisterErrorState) {
          // ErrorService.showSnackbarError(11
          //   state.error ?? 'unknownError',
          //   rentxcontext,
          //   SnackbarType.error,
          // );
        }
      }),
    );
  }
}
