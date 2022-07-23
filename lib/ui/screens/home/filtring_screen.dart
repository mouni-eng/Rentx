import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rentx/models/car.dart';
import 'package:rentx/models/car_mdels.dart';
import 'package:rentx/size_config.dart';
import 'package:rentx/ui/base_widget.dart';
import 'package:rentx/ui/components/custom_button.dart';
import 'package:rentx/ui/components/custom_form_field.dart';
import 'package:rentx/ui/components/custom_text.dart';
import 'package:rentx/ui/components/header_widget.dart';
import 'package:rentx/ui/screens/search_screen.dart';
import 'package:rentx/view_models/filter_cubit/cubit.dart';
import 'package:rentx/view_models/filter_cubit/states.dart';
import 'package:rentx/view_models/search_cubit/cubit.dart';

class FilterScreenWidget extends StatelessWidget {
  const FilterScreenWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RentXWidget(
      builder: (rentxcontext) => BlocConsumer<FilterCubit, FilterStates>(
        listener: (context, state) {
          if (state is FilterSavedState) {
            SearchCubit.get(context)
                .searchFiltered(FilterCubit.get(context).filterModel);
            rentxcontext.route((p0) => const SearchRentalScreen());
          }
        },
        builder: (context, state) {
          FilterCubit cubit = FilterCubit.get(context);
          return ConditionalBuilder(
              condition: state is! FilterLoadingState,
              builder: (context) => Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                      color: rentxcontext.theme.customTheme.onPrimary,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: width(16),
                        vertical: height(21),
                      ),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                    color: rentxcontext
                                        .theme.customTheme.headdline,
                                  ),
                                ),
                                CustomText(
                                  color:
                                      rentxcontext.theme.customTheme.headdline,
                                  fontSize: width(16),
                                  fontWeight: FontWeight.w600,
                                  text: rentxcontext.translate("filters"),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    cubit.resetFilter();
                                  },
                                  child: CustomText(
                                    color: rentxcontext
                                        .theme.customTheme.headdline,
                                    fontSize: width(14),
                                    text: rentxcontext.translate("reset"),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: height(24),
                            ),
                            CustomFormField(
                              context: context,
                              prefix: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: width(16),
                                  vertical: height(16),
                                ),
                                child: SvgPicture.asset(
                                  "assets/img/search.svg",
                                ),
                              ),
                              hintText:
                                  '${rentxcontext.translate("searchHere")}...',
                            ),
                            SizedBox(
                              height: height(24),
                            ),
                            HeaderWidget(
                              title: rentxcontext.translate("brand"),
                              fontWeight: FontWeight.w500,
                            ),
                            SizedBox(
                              height: height(16),
                            ),
                            SizedBox(
                              height: height(60),
                              child: ListView.separated(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  final TopBrandsResult carBrandModel =
                                      cubit.carBrands![index];
                                  return cubit.brandChosen?.id ==
                                          carBrandModel.id
                                      ? ChoosenFilterItem(
                                          title: carBrandModel.make!)
                                      : GestureDetector(
                                          onTap: () {
                                            cubit.chooseBrand(
                                                cubit.carBrands![index]);
                                          },
                                          child: FilterItem(
                                            title: carBrandModel.make!,
                                          ),
                                        );
                                },
                                separatorBuilder: (context, index) => SizedBox(
                                  width: width(16),
                                ),
                                itemCount: cubit.carBrands?.length ?? 0,
                              ),
                            ),
                            SizedBox(
                              height: height(24),
                            ),
                            const Divider(
                              thickness: 1,
                              color: Color(0xFFE0E0E0),
                            ),
                            SizedBox(
                              height: height(24),
                            ),
                            HeaderWidget(
                              title: rentxcontext.translate("carType"),
                              fontWeight: FontWeight.w500,
                            ),
                            SizedBox(
                              height: height(16),
                            ),
                            SizedBox(
                              height: height(60),
                              child: ListView.separated(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  final CarType carType =
                                      cubit.carTypeValues![index];
                                  return cubit.carTypeChosen ==
                                          cubit.carTypeValues![index]
                                      ? ChoosenFilterItem(title: carType.name)
                                      : GestureDetector(
                                          onTap: () {
                                            cubit.chooseCarType(carType);
                                          },
                                          child: FilterItem(
                                            title: carType.name,
                                          ),
                                        );
                                },
                                separatorBuilder: (context, index) => SizedBox(
                                  width: width(16),
                                ),
                                itemCount: cubit.carTypeValues!.length,
                              ),
                            ),
                            SizedBox(
                              height: height(24),
                            ),
                            const Divider(
                              thickness: 1,
                              color: Color(0xFFE0E0E0),
                            ),
                            SizedBox(
                              height: height(24),
                            ),
                            HeaderWidget(
                              title: rentxcontext.translate("seats"),
                              fontWeight: FontWeight.w500,
                            ),
                            SizedBox(
                              height: height(24),
                            ),
                            SizedBox(
                              height: height(60),
                              child: ListView.separated(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  final String seat = cubit.seatValues![index];
                                  return cubit.seatChosen ==
                                          cubit.seatValues![index]
                                      ? ChoosenFilterItem(title: seat)
                                      : GestureDetector(
                                          onTap: () {
                                            cubit.chooseSeat(seat);
                                          },
                                          child: FilterItem(
                                            title: seat,
                                          ),
                                        );
                                },
                                separatorBuilder: (context, index) => SizedBox(
                                  width: width(16),
                                ),
                                itemCount: cubit.seatValues!.length,
                              ),
                            ),
                            const Divider(
                              thickness: 1,
                              color: Color(0xFFE0E0E0),
                            ),
                            SizedBox(
                              height: height(24),
                            ),
                            CustomText(
                              color: rentxcontext.theme.customTheme.headdline,
                              fontSize: width(14),
                              fontWeight: FontWeight.w500,
                              text: rentxcontext.translate("transmission"),
                            ),
                            SizedBox(
                              height: height(16),
                            ),
                            SizedBox(
                              height: height(60),
                              child: ListView.separated(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  final String transmission =
                                      cubit.transmissionValues![index];
                                  return cubit.transmissionChosen ==
                                          transmission
                                      ? ChoosenFilterItem(title: transmission)
                                      : GestureDetector(
                                          onTap: () {
                                            cubit.chooseTransmission(
                                                transmission);
                                          },
                                          child: FilterItem(
                                            title: transmission,
                                          ),
                                        );
                                },
                                separatorBuilder: (context, index) => SizedBox(
                                  width: width(16),
                                ),
                                itemCount: cubit.transmissionValues!.length,
                              ),
                            ),
                            SizedBox(
                              height: height(24),
                            ),
                            const Divider(
                              thickness: 1,
                              color: Color(0xFFE0E0E0),
                            ),
                            SizedBox(
                              height: height(24),
                            ),
                            CustomText(
                                color: rentxcontext.theme.customTheme.secondary,
                                fontSize: width(14),
                                fontWeight: FontWeight.w500,
                                text: "priceRange"),
                            SizedBox(
                              height: height(4),
                            ),
                            Row(
                              children: [
                                CustomText(
                                    color: rentxcontext
                                        .theme.customTheme.secondary,
                                    fontSize: width(22),
                                    text:
                                        "€${cubit.rangeValues.start.toInt().toString()} - €${cubit.rangeValues.end.toInt().toString()}"),
                              ],
                            ),
                            SizedBox(
                              height: height(27),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: width(11)),
                              child: RangeSlider(
                                values: cubit.rangeValues,
                                onChanged: (value) {
                                  cubit.chooseCarPrice(value);
                                },
                                min: 10,
                                max: 1000,
                              ),
                            ),
                            SizedBox(
                              height: height(46),
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: width(84),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    cubit.resetFilter();
                                    Navigator.pop(context);
                                  },
                                  child: CustomText(
                                      color: rentxcontext
                                          .theme.customTheme.headdline,
                                      fontSize: width(16),
                                      text: rentxcontext.translate("cancel")),
                                ),
                                const Spacer(),
                                CustomButton(
                                  fontSize: width(16),
                                  btnWidth: width(132),
                                  radius: 8,
                                  isUpperCase: false,
                                  function: () {
                                    cubit.saveFilter();
                                  },
                                  text: rentxcontext.translate("save"),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
              fallback: (context) => const Center(
                    child: CircularProgressIndicator.adaptive(),
                  ));
        },
      ),
    );
  }
}

class FilterItem extends StatelessWidget {
  const FilterItem({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return RentXWidget(
      builder: (rentxcontext) => Container(
        height: height(37),
        padding: EdgeInsets.symmetric(
          horizontal: width(14),
          vertical: height(8),
        ),
        margin: EdgeInsets.symmetric(
          vertical: height(10),
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFFE0E0E0),
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: CustomText(
          color: rentxcontext.theme.customTheme.headline3,
          fontSize: width(14),
          text: rentxcontext.translate(title.toLowerCase()),
        ),
      ),
    );
  }
}

class ChoosenFilterItem extends StatelessWidget {
  const ChoosenFilterItem({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return RentXWidget(
      builder: (rentxcontext) => Container(
        height: height(37),
        padding: EdgeInsets.symmetric(
          horizontal: width(14),
          vertical: height(8),
        ),
        margin: EdgeInsets.symmetric(
          vertical: height(10),
        ),
        decoration: BoxDecoration(
          color: rentxcontext.theme.customTheme.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            CustomText(
              color: rentxcontext.theme.customTheme.onPrimary,
              fontSize: width(14),
              text: rentxcontext.translate(title),
            ),
            SvgPicture.asset("assets/img/check-small.svg"),
          ],
        ),
      ),
    );
  }
}
