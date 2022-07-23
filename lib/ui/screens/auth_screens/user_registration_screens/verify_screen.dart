import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentx/services/alert_service.dart';
import 'package:rentx/ui/base_widget.dart';
import 'package:rentx/ui/components/verify_otp_component.dart';
import 'package:rentx/view_models/auth_cubit/cubit.dart';
import 'package:rentx/view_models/auth_cubit/states.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RentXWidget(
      builder: (rentxcontext) => BlocConsumer<AuthCubit, AuthStates>(
        builder: (context, state) {
          AuthCubit cubit = AuthCubit.get(context);
          return VerifyOtpWidget(
              loading: state is EmailConfirmedLoadingState,
              validator: (value) {
                if (value == null && value!.length < 6) {
                  return 'required';
                }
                return cubit.emailConfirmationCodeValidation;
              },
              onChanged: cubit.onChangePin,
              email: cubit.email!,
              focusNode: cubit.focusNode,
              formKey: cubit.formKey3,
              onSubmit: () {
                cubit.onNextValidation(context);
              });
        },
        listener: (context, state) {
          if (state is RegisterErrorState) {
            if (state.error != 'ConfirmEmail') {
              AlertService.showSnackbarAlert(
                  state.error!, rentxcontext, SnackbarType.error);
            }
          }
        },
      ),
    );
  }
}
