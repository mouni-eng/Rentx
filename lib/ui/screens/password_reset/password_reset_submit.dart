import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentx/helper/validation.dart';
import 'package:rentx/size_config.dart';
import 'package:rentx/ui/base_widget.dart';
import 'package:rentx/ui/components/custom_button.dart';
import 'package:rentx/ui/screens/car_listing_screens/create/steps/set_properties.dart';
import 'package:rentx/view_models/password_reset_cubit/cubit.dart';
import 'package:rentx/view_models/password_reset_cubit/states.dart';

class PasswordResetSubmitStep extends StatelessWidget {
  const PasswordResetSubmitStep({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RentXWidget(
      builder: (rentXContext) =>
          BlocConsumer<PasswordResetCubit, PasswordResetState>(
              builder: (context, state) {
                PasswordResetCubit cubit = PasswordResetCubit.get(context);
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Form(
                    key: cubit.resetFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PropertiesWidget(
                            name: "newPassword",
                            isPassword: true,
                            validate: (value) => Validators.minLength(8, value),
                            onChange: (value) {
                              cubit.onChangePassword(value);
                            }),
                        PropertiesWidget(
                            isPassword: true,
                            name: "confirmPassword",
                            validate: (value) => Validators.matchesPassword(
                                value, cubit.password),
                            onChange: (value) {
                              cubit.onChangeConfirmPassword(value);
                            }),
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
                                    rentXContext.translate("Back"),
                                    style: TextStyle(
                                      fontSize: width(16),
                                      color: rentXContext
                                          .theme.customTheme.headdline,
                                    ),
                                  )),
                            if (cubit.index == 0) Container(),
                            CustomButton(
                              showLoader: state is PasswordResetSubmittedState,
                              text: rentXContext.translate("next"),
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
              },
              listener: (context, state) {}),
    );
  }
}
