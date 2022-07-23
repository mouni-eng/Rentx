import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentx/ui/base_widget.dart';
import 'package:rentx/ui/components/verify_otp_component.dart';
import 'package:rentx/view_models/password_reset_cubit/cubit.dart';
import 'package:rentx/view_models/password_reset_cubit/states.dart';

class PasswordResetConfirmationStep extends StatelessWidget {
  const PasswordResetConfirmationStep({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RentXWidget(
      builder: (rentxcontext) =>
          BlocConsumer<PasswordResetCubit, PasswordResetState>(
        builder: (context, state) {
          PasswordResetCubit cubit = PasswordResetCubit.get(context);
          return VerifyOtpWidget(
              focusNode: FocusNode(),
              loading: state is PasswordResetOtpValidatingState,
              validator: (value) {
                if (value == null && value!.length < 6) {
                  return 'required';
                }
                return cubit.otpValidation;
              },
              onChanged: cubit.onOtpChange,
              email: cubit.email!,
              formKey: cubit.otpFormKey,
              onSubmit: () {
                cubit.onNextValidation(context);
              });
        },
        listener: (context, state) {},
      ),
    );
  }
}
