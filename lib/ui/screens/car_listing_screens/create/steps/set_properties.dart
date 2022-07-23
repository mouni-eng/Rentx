import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentx/models/car.dart';
import 'package:rentx/models/input_properties.dart';
import 'package:rentx/size_config.dart';
import 'package:rentx/ui/base_widget.dart';
import 'package:rentx/ui/components/chip_properties_widget.dart';
import 'package:rentx/ui/components/custom_form_field.dart';
import 'package:rentx/ui/components/custom_text.dart';
import 'package:rentx/view_models/car_listing_cubit/cubit.dart';
import 'package:rentx/view_models/car_listing_cubit/states.dart';

class SetPropertiesWidget extends StatelessWidget {
  const SetPropertiesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RentXWidget(
      builder: (context) => BlocConsumer<CarListingCubit, CarListingStates>(
        listener: (context, state) {},
        builder: (context, state) {
          CarListingCubit cubit = CarListingCubit.get(context);
          return ConditionalBuilder(
              condition: state is CarPropertiesLoadingState,
              builder: (context) => const Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
              fallback: (context) => SingleChildScrollView(
                    child: Form(
                      key: cubit.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...cubit.carPropertyInputs!
                              .map((e) => _buildWidgetFromProperty(e, cubit))
                              .toList(),
                        ],
                      ),
                    ),
                  ));
        },
      ),
    );
  }

  Widget _buildWidgetFromProperty(CarPropertyInput e, CarListingCubit cubit) {
    if (e.type == DataTypeEnum.input) {
      return PropertiesWidget(
          validate: (p0) => null,
          name: e.key!.name,
          onChange: (v) {
            cubit.addCarProperties(e.key!, v);
          });
    }
    return ChipPropertiesWidget(
        values: e.values!.map((e) => StringChipModel(e.toString())).toList(),
        label: e.key!.name,
        onSelect: (prop) {
          cubit.addCarProperties(e.key!, prop.get());
        },
        selectedValue: StringChipModel(cubit.properties[e.key!] ?? ''));
  }
}

class PropertiesWidget extends StatelessWidget {
  const PropertiesWidget({
    Key? key,
    required this.name,
    required this.onChange,
    this.isDiscription = false,
    this.isPassword = false,
    this.isMaxChar = false,
    this.isPhoneNumber = false,
    this.validate,
  }) : super(key: key);

  final String name;
  final bool isPassword;
  final bool isDiscription;
  final bool isMaxChar;
  final bool isPhoneNumber;
  final String? Function(String?)? validate;
  final Function(String)? onChange;

  @override
  Widget build(BuildContext context) {
    return RentXWidget(
      builder: (rentcontext) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
              color: rentcontext.theme.customTheme.headdline,
              fontSize: width(14),
              fontWeight: FontWeight.w500,
              text: rentcontext.translate(name)),
          SizedBox(
            height: height(5),
          ),
          CustomFormField(
            context: context,
            isPassword: isPassword,
            isAboutMe: isDiscription,
            maxLines: isDiscription ? 20 : 1,
            type: isPhoneNumber
                ? TextInputType.phone
                : TextInputType.emailAddress,
            hintText: rentcontext.translate("Enter here"),
            onChange: onChange,
            validate: (value) {
              if (validate != null) {
                final String? validation = validate!.call(value);
                return validation != null
                    ? rentcontext.translate(validation)
                    : null;
              }
              return value!.isEmpty ? rentcontext.translate('required') : null;
            },
          ),
          if (isMaxChar)
            Column(
              children: [
                SizedBox(
                  height: height(6),
                ),
                CustomText(
                  color: rentcontext.theme.customTheme.primary,
                  fontSize: width(12),
                  text: "Max 20 characters",
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
          SizedBox(
            height: height(24),
          ),
        ],
      ),
    );
  }
}
