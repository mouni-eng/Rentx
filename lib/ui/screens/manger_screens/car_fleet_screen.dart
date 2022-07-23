import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentx/size_config.dart';
import 'package:rentx/ui/base_widget.dart';
import 'package:rentx/ui/components/car_fleet_widget.dart';
import 'package:rentx/ui/components/custom_button.dart';
import 'package:rentx/ui/components/custom_text.dart';
import 'package:rentx/ui/screens/car_listing_screens/create/create_car_listing_screen.dart';
import 'package:rentx/ui/screens/layout_screens/profile_screen.dart';
import 'package:rentx/view_models/car_fleet_cubit/cubit.dart';
import 'package:rentx/view_models/car_fleet_cubit/states.dart';
import 'package:rentx/view_models/car_listing_cubit/cubit.dart';
import 'package:rentx/view_models/manager_cubit/cubit.dart';

import '../car_fleet_screen.dart';

class CarFleetListScreen extends StatelessWidget {
  const CarFleetListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return RentXWidget(
      builder: (rentxcontext) => BlocConsumer<CarFleetCubit, CarFleetStates>(
          listener: (context, state) {},
          builder: (context, state) {
            CarFleetCubit cubit = CarFleetCubit.get(context);
            return SafeArea(
                child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width(24),
                vertical: height(16),
              ),
              child: ConditionalBuilder(
                condition: state is! GetCarFleetLoadingStae,
                fallback: (context) => const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
                builder: (context) => Stack(
                  children: [
                    SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              BackButtonWidget(
                                onTap: () {
                                  ManagerCubit.get(context).changeBottomNav(0);
                                },
                                rentxcontext: rentxcontext,
                              ),
                              SizedBox(
                                width: width(16),
                              ),
                              CustomText(
                                color: rentxcontext.theme.customTheme.headdline,
                                fontSize: width(22),
                                text: "Car Fleet",
                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height(30),
                          ),
                          CarFleetList(
                            rentals: cubit.carFleets,
                            onItemTapFn: (rental) {
                              CarFleetCubit.get(context)
                                  .getCarFleetDetails(rental.id!);
                              rentxcontext
                                  .route((p0) => const CarFleetScreen());
                            },
                          ),
                          SizedBox(
                            height: height(25),
                          ),
                          CustomButton(
                            background: rentxcontext.theme.customTheme.primary,
                            text: "addCarFleet",
                            fontSize: width(16),
                            function: () {
                              CarListingCubit.get(context).getCarsData();
                              rentxcontext.route(
                                  (p0) => const CreateCarListingScreen());
                            },
                            svgLeadingIcon: 'assets/img/add.svg',
                          ),
                          SizedBox(
                            height: height(15),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ));
          }),
    );
  }
}
