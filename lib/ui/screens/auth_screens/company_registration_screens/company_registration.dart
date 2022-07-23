import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:rentx/size_config.dart';
import 'package:rentx/theme/app_theme.dart';
import 'package:rentx/ui/base_widget.dart';
import 'package:rentx/ui/components/custom_text.dart';
import 'package:rentx/ui/screens/manger_screens/manager_layout_screen.dart';
import 'package:rentx/view_models/booking_cubit/cubit.dart';
import 'package:rentx/view_models/company_auth_cubit/cubit.dart';
import 'package:rentx/view_models/company_auth_cubit/states.dart';

class CompanyRegistrationScreen extends StatelessWidget {
  const CompanyRegistrationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return RentXWidget(
        builder: (rentXContext) => Scaffold(
              backgroundColor: AppTheme.theme.backgroundColor,
              body: SafeArea(
                  child: BlocConsumer<CompanyAuthCubit, CompanyAuthStates>(
                listener: (context, state) {
                  if (state is CompanyRegisterSuccessState) {
                    BookingCubit.get(context).getBookings();
                    rentXContext.route((p0) => const ManagerLayoutScreen());
                  }
                },
                builder: (context, state) {
                  CompanyAuthCubit cubit = CompanyAuthCubit.get(context);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: width(24),
                          vertical: height(24),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                                color: rentXContext
                                    .theme.customTheme.secondary,
                                fontSize: width(22),
                                fontWeight: FontWeight.w600,
                                text: rentXContext.translate(cubit
                                    .companyHeaders[cubit.companyIndex])),
                            SizedBox(
                              height: height(5),
                            ),
                            Row(
                              children: [
                                CustomText(
                                    color: rentXContext
                                        .theme.customTheme.primary,
                                    fontSize: width(16),
                                    fontWeight: FontWeight.w600,
                                    text: rentXContext.translate(
                                        "Step ${cubit.companyIndex + 1}")),
                                CustomText(
                                    color: rentXContext
                                        .theme.customTheme.kSecondaryColor,
                                    fontSize: width(16),
                                    text: rentXContext.translate(" to 2 ")),
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
                              percent: cubit.companyPercent,
                              padding: EdgeInsets.zero,
                              backgroundColor: rentXContext.theme.customTheme.onPrimary,
                              progressColor:
                                  rentXContext.theme.customTheme.primary,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: PageView.builder(
                          controller: cubit.companyController,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: cubit.companySteps.length,
                          itemBuilder: (BuildContext context, int no) {
                            return cubit.companySteps[no];
                          },
                        ),
                      ),
                      
                    ],
                  );
                },
              )),
            ));
  }
}
