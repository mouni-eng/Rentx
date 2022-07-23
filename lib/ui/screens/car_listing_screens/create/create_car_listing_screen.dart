import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:rentx/size_config.dart';
import 'package:rentx/theme/app_theme.dart';
import 'package:rentx/ui/base_widget.dart';
import 'package:rentx/ui/components/custom_button.dart';
import 'package:rentx/ui/components/custom_text.dart';
import 'package:rentx/ui/screens/completed_screen.dart';
import 'package:rentx/ui/screens/manger_screens/manager_layout_screen.dart';
import 'package:rentx/view_models/car_fleet_cubit/cubit.dart';
import 'package:rentx/view_models/car_listing_cubit/cubit.dart';
import 'package:rentx/view_models/car_listing_cubit/states.dart';

class CreateCarListingScreen extends StatelessWidget {
  const CreateCarListingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return RentXWidget(
        builder: (rentXContext) => Scaffold(
              backgroundColor: AppTheme.theme.backgroundColor,
              body: SafeArea(
                  child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: width(24),
                  vertical: height(24),
                ),
                child: BlocConsumer<CarListingCubit, CarListingStates>(
                  listener: (context, state) {
                    if (state is RentalCreatedState) {
                      rentXContext.route((p0) => CompletedScreen(
                          text: 'rentalCreated.text',
                          onBtnClick: () {
                            CarFleetCubit.get(context).getCarFleet();
                            rentXContext
                                .route((p0) => const ManagerLayoutScreen());
                          }));
                    }
                  },
                  builder: (context, state) {
                    CarListingCubit cubit = CarListingCubit.get(context);
                    return SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: RentXWidget(
                          builder: (rentcontext) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                  color:
                                      rentcontext.theme.customTheme.secondary,
                                  fontSize: width(22),
                                  text: rentcontext
                                      .translate(cubit.headers[cubit.index])),
                              SizedBox(
                                height: height(5),
                              ),
                              Row(
                                children: [
                                  CustomText(
                                      color:
                                          rentcontext.theme.customTheme.primary,
                                      fontSize: width(16),
                                      text: rentcontext.translate(
                                          "Step ${cubit.index + 1}")),
                                  CustomText(
                                      color: rentcontext
                                          .theme.customTheme.kSecondaryColor,
                                      fontSize: width(16),
                                      text: rentcontext.translate(" to 4 ")),
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
                                backgroundColor: const Color(0xFFE1E5EF),
                                progressColor:
                                    rentcontext.theme.customTheme.primary,
                              ),
                              SizedBox(
                                height: height(30),
                              ),
                              SizedBox(
                                height: height(525),
                                child: PageView.builder(
                                  controller: cubit.controller,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: cubit.steps.length,
                                  itemBuilder: (BuildContext context, int no) {
                                    return cubit.steps[no];
                                  },
                                ),
                              ),
                              SizedBox(
                                height: height(20),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  if (cubit.index != 0)
                                    TextButton(
                                        onPressed: () {
                                          cubit.onBackStep();
                                        },
                                        child: Text(
                                          rentcontext.translate("Back"),
                                          style: TextStyle(
                                            fontSize: width(16),
                                            color: rentcontext
                                                .theme.customTheme.secondary,
                                          ),
                                        )),
                                  if (cubit.index == 0) Container(),
                                  CustomButton(
                                    showLoader:
                                        state is RentalCreationInProgress,
                                    text: cubit.isLast
                                        ? rentcontext.translate("Done")
                                        : rentcontext.translate("Next"),
                                    radius: 6,
                                    fontSize: width(16),
                                    btnWidth: width(132),
                                    function: () {
                                      cubit.validateNext(context);
                                    },
                                    isUpperCase: false,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ));
                  },
                ),
              )),
            ));
  }
}
