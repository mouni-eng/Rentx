import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentx/helper/validation.dart';
import 'package:rentx/size_config.dart';
import 'package:rentx/ui/base_widget.dart';
import 'package:rentx/ui/components/custom_dropdown_search.dart';
import 'package:rentx/ui/components/custom_text.dart';
import 'package:rentx/view_models/car_listing_cubit/cubit.dart';
import 'package:rentx/view_models/car_listing_cubit/states.dart';

class MakeModelWidget extends StatelessWidget {
  const MakeModelWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CarListingCubit, CarListingStates>(
      listener: (context, state) {},
      builder: (context, state) {
        CarListingCubit cubit = CarListingCubit.get(context);
        return RentXWidget(
          builder: (context) => SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                    color: context.theme.customTheme.secondary,
                    fontSize: width(14),
                    text: context.translate("Make")),
                SizedBox(
                  height: height(5),
                ),
                CustomDropdownSearch<String>(
                    entries: cubit.carBrands
                        .map(
                            (e) => KeyValue<String>(value: e.make!, key: e.id!))
                        .toList(),
                    onChange: (kv) => cubit.chooseCarMake(kv.key),
                    label: 'selectMake'),
                SizedBox(
                  height: height(24),
                ),
                CustomText(
                    color: context.theme.customTheme.secondary,
                    fontSize: width(14),
                    text: context.translate("Model")),
                SizedBox(
                  height: height(5),
                ),
                CustomDropdownSearch<String>(
                    validator: Validators.required,
                    enabled: cubit.carChoosen != null,
                    entries: cubit.carBrandModels
                        .map((e) => KeyValue<String>(
                            value:
                                '${e.model!} (${context.translate(e.type!.name)})',
                            key: e.id!))
                        .toList(),
                    onChange: (kv) => cubit.chooseCarModel(kv.key),
                    label: 'selectModel'),
              ],
            ),
          ),
        );
      },
    );
  }
}
