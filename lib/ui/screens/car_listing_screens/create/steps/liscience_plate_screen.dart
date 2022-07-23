import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentx/size_config.dart';
import 'package:rentx/ui/base_widget.dart';
import 'package:rentx/ui/components/custom_text.dart';
import 'package:rentx/ui/screens/car_listing_screens/create/steps/set_properties.dart';
import 'package:rentx/view_models/car_listing_cubit/cubit.dart';
import 'package:rentx/view_models/car_listing_cubit/states.dart';

class LisencePlateWidget extends StatelessWidget {
  const LisencePlateWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CarListingCubit, CarListingStates>(
      listener: (context, state) {},
      builder: (context, state) {
        CarListingCubit cubit = CarListingCubit.get(context);
        return RentXWidget(
            builder: (context) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PropertiesWidget(
                        name: "Lience Plate",
                        onChange: (value) {
                          cubit.chooseCarLicsense(value);
                        }),
                    SizedBox(
                      height: height(24),
                    ),
                    CustomText(
                        color: context.theme.customTheme.secondary,
                        fontSize: width(14),
                        text: "Price Range"),
                    SizedBox(
                      height: height(4),
                    ),
                    Row(
                      children: [
                        CustomText(
                            color: context.theme.customTheme.secondary,
                            fontSize: width(22),
                            text:
                                "€${cubit.rangeValues.start.toInt().toString()} - €${cubit.rangeValues.end.toInt().toString()}"),
                      ],
                    ),
                    SizedBox(
                      height: height(27),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width(11)),
                      child: RangeSlider(
                        values: cubit.rangeValues,
                        onChanged: (value) {
                          cubit.chooseCarPrice(value);
                        },
                        min: 10,
                        max: 1000,
                      ),
                    ),
                  ],
                ));
      },
    );
  }
}
