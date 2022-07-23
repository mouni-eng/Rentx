import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:rentx/size_config.dart';
import 'package:rentx/ui/base_widget.dart';
import 'package:rentx/ui/components/custom_text.dart';
import 'package:rentx/ui/screens/auth_screens/logIn_screen.dart';
import 'package:rentx/ui/screens/completed_screen.dart';
import 'package:rentx/view_models/password_reset_cubit/cubit.dart';
import 'package:rentx/view_models/password_reset_cubit/states.dart';

class PasswordResetScreen extends StatelessWidget {
  const PasswordResetScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return RentXWidget(
        builder: (rentXContext) => Scaffold(
              backgroundColor: rentXContext.theme.theme.scaffoldBackgroundColor,
              body: SafeArea(
                  child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: width(24),
                  vertical: height(24),
                ),
                child: BlocConsumer<PasswordResetCubit, PasswordResetState>(
                  listener: (context, state) {
                    if (state is PasswordResetSuccessState) {
                      rentXContext.route((context) => CompletedScreen(
                          title: 'passwordReset.title',
                          text: 'passwordReset.text',
                          btnText: 'logIn',
                          onBtnClick: () =>
                              rentXContext.route((context) => LogInScreen())));
                    }
                  },
                  builder: (context, state) {
                    PasswordResetCubit cubit = PasswordResetCubit.get(context);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                            color: rentXContext.theme.customTheme.secondary,
                            fontSize: width(22),
                            fontWeight: FontWeight.w600,
                            text: rentXContext
                                .translate(cubit.headers[cubit.index])),
                        SizedBox(
                          height: height(5),
                        ),
                        Row(
                          children: [
                            CustomText(
                                color: rentXContext.theme.customTheme.primary,
                                fontSize: width(16),
                                fontWeight: FontWeight.w600,
                                text: rentXContext
                                    .translate("Step ${cubit.index + 1}")),
                            CustomText(
                                color: rentXContext
                                    .theme.customTheme.kSecondaryColor,
                                fontSize: width(16),
                                text: rentXContext.translate(" to 3 ")),
                          ],
                        ),
                        SizedBox(
                          height: height(14),
                        ),
                        LinearPercentIndicator(
                          width: width(320),
                          lineHeight: height(5),
                          animation: true,
                          barRadius: const Radius.circular(6),
                          percent: cubit.percent,
                          padding: EdgeInsets.zero,
                          backgroundColor:
                              rentXContext.theme.customTheme.onPrimary,
                          progressColor: rentXContext.theme.customTheme.primary,
                        ),
                        SizedBox(
                          height: height(30),
                        ),
                        Expanded(
                          child: PageView.builder(
                            controller: cubit.stepController,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: cubit.steps.length,
                            itemBuilder: (BuildContext context, int no) {
                              return cubit.steps[no];
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              )),
            ));
  }
}
