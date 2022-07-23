import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rentx/constants.dart';
import 'package:rentx/infrastructure/utils.dart';
import 'package:rentx/models/car.dart';
import 'package:rentx/models/rental_model.dart';
import 'package:rentx/size_config.dart';
import 'package:rentx/ui/base_widget.dart';
import 'package:rentx/ui/components/custom_form_field.dart';
import 'package:rentx/ui/components/custom_overlay_dropDown.dart';
import 'package:rentx/ui/components/custom_table_calendar.dart';
import 'package:rentx/ui/components/custom_text.dart';
import 'package:rentx/ui/components/price_tag.dart';
import 'package:rentx/ui/screens/car_listing_screens/car_listing_screen.dart';
import 'package:rentx/view_models/filter_cubit/cubit.dart';
import 'package:rentx/view_models/rental_details_cubit/cubit.dart';
import 'package:rentx/view_models/rental_details_cubit/states.dart';
import 'package:rentx/view_models/search_cubit/cubit.dart';
import 'package:rentx/view_models/search_cubit/states.dart';

import 'home/filtring_screen.dart';
import 'layout_screens/profile_screen.dart';

class SearchRentalScreen extends StatelessWidget {
  const SearchRentalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RentXWidget(
        builder: (rentxcontext) => BlocConsumer<SearchCubit, SearchStates>(
            listener: (context, state) {},
            builder: (context, state) {
              SearchCubit cubit = SearchCubit.get(context);
              return Scaffold(
                body: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: width(16),
                      vertical: height(16),
                    ),
                    child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                BackButtonWidget(
                                  rentxcontext: rentxcontext,
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                SizedBox(
                                  width: width(8),
                                ),
                                Expanded(
                                  child: CustomFormField(
                                    context: context,
                                    hintText: "Search here....",
                                    prefix: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: width(17),
                                        vertical: height(17),
                                      ),
                                      child: SvgPicture.asset(
                                        "assets/img/search.svg",
                                      ),
                                    ),
                                    suffix: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: width(17),
                                        vertical: height(17),
                                      ),
                                      child: SvgPicture.asset(
                                          "assets/img/close.svg"),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: width(8),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    FilterCubit.get(context).initialize();
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (context) =>
                                            const FilterScreenWidget());
                                  },
                                  child: Container(
                                    width: width(46),
                                    height: height(46),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: rentxcontext
                                            .theme.customTheme.outerBorder,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: width(10),
                                        vertical: height(10),
                                      ),
                                      child: SvgPicture.asset(
                                          "assets/img/filter.svg"),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: height(8),
                            ),
                            CustomOverLayWidget(
                              widgetBuilder: CalanderFilterBar(
                                  dateTime: cubit.rangeStart != null &&
                                          cubit.rangeEnd != null
                                      ? DateUtil.displayRange(
                                          cubit.rangeStart!,
                                          cubit.rangeEnd!,
                                        )
                                      : null),
                              overlayBuilder: const CalanderFilterData(),
                              overLayHeight: height(450),
                              visible: cubit.isCalanderVisible,
                              onDismiss: cubit.toogleVisiblity,
                            ),
                            SizedBox(
                              height: height(24),
                            ),
                            CustomText(
                              color: rentxcontext.theme.customTheme.headdline,
                              fontSize: width(16),
                              text: "Results (${cubit.mapRentals.length})",
                              fontWeight: FontWeight.w600,
                            ),
                            SizedBox(
                              height: height(12),
                            ),
                            ConditionalBuilder(
                                condition: state is! SearchLoadingState &&
                                    state is! GetMapRentalsLoadingState,
                                builder: (context) => ListView.separated(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) =>
                                          CustomRentalSearchScreen(
                                        rentxcontext: rentxcontext,
                                        model: cubit.mapRentals[index],
                                      ),
                                      separatorBuilder: (context, index) =>
                                          SizedBox(
                                        height: height(16),
                                      ),
                                      itemCount: cubit.mapRentals.length,
                                    ),
                                fallback: (context) => const Center(
                                      child:
                                          CircularProgressIndicator.adaptive(),
                                    )),
                          ],
                        )),
                  ),
                ),
              );
            }));
  }
}

class CalanderFilterData extends StatelessWidget {
  const CalanderFilterData({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RentXWidget(
        builder: (rentxcontext) => BlocConsumer<SearchCubit, SearchStates>(
            listener: (context, state) {},
            builder: (contexct, state) {
              SearchCubit cubit = SearchCubit.get(context);
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    boxShadow,
                  ],
                  color: rentxcontext.theme.customTheme.onPrimary,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: height(350),
                      child: CustomTableCalendar(
                          selectedDay: cubit.selectedDay,
                          startDay: cubit.rangeStart,
                          endDay: cubit.rangeEnd,
                          focusedDay: cubit.focusedDay,
                          onChangeFormat: cubit.toggleFormat,
                          onChangeRange: cubit.chooseDateEnd,
                          onChangeDay: cubit.chooseDate,
                          rangeSelectionMode: cubit.rangeSelectionMode,
                          calendarFormat: cubit.calendarFormat),
                    ),
                    SizedBox(
                      height: height(24),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: cubit.toogleVisiblity,
                          child: CustomText(
                            color: rentxcontext.theme.customTheme.headline2,
                            fontSize: width(16),
                            text: "Cancel",
                          ),
                        ),
                        Container(
                          width: width(132),
                          height: height(48),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: rentxcontext.theme.customTheme.primary,
                          ),
                          child: MaterialButton(
                            onPressed: cubit.applyCalanderFilter,
                            child: CustomText(
                              color: rentxcontext.theme.customTheme.onPrimary,
                              fontSize: width(16),
                              text: "Apply",
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              );
            }),
      ),
    );
  }
}

class CalanderFilterBar extends StatelessWidget {
  const CalanderFilterBar({
    Key? key,
    this.dateTime,
  }) : super(key: key);

  final String? dateTime;

  @override
  Widget build(BuildContext context) {
    return RentXWidget(
      builder: (rentxcontext) => Container(
        width: double.infinity,
        height: height(46),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: rentxcontext.theme.customTheme.outerBorder,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width(16),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                "assets/img/calendar.svg",
                color: rentxcontext.theme.customTheme.primary,
              ),
              SizedBox(
                width: width(11),
              ),
              CustomText(
                color: rentxcontext.theme.customTheme.primary,
                fontSize: width(12),
                text: dateTime ?? "choose Date",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomRentalSearchScreen extends StatelessWidget {
  const CustomRentalSearchScreen({
    Key? key,
    required this.model,
    required this.rentxcontext,
  }) : super(key: key);

  final RentalResult model;
  final RentXContext rentxcontext;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        RentalDetailsCubit.get(context).getRentalDetails(model.id!);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const RentalCarListingScreen(),
            ));
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: width(16),
          vertical: height(16),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: rentxcontext.theme.customTheme.onPrimary,
          boxShadow: [
            boxShadow,
          ],
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                          color: rentxcontext.theme.customTheme.headdline,
                          fontSize: width(16),
                          fontWeight: FontWeight.w600,
                          text: "${model.car!.make!} ${model.car!.model!}"),
                      SizedBox(
                        height: height(8),
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            "assets/img/speedometer.svg",
                          ),
                          SizedBox(
                            width: width(6),
                          ),
                          CustomText(
                              color: rentxcontext.theme.customTheme.headline3,
                              fontSize: width(12),
                              text: model
                                      .getProperty(CarPropertyType.transmission)
                                      ?.value ??
                                  '-'),
                        ],
                      ),
                      SizedBox(
                        height: height(8),
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            "assets/img/sport-car.svg",
                          ),
                          SizedBox(
                            width: width(6),
                          ),
                          CustomText(
                              color: rentxcontext.theme.customTheme.headline3,
                              fontSize: width(12),
                              text:
                                  "${model.getProperty(CarPropertyType.engine)?.value ?? '-'} Engine"),
                        ],
                      ),
                      SizedBox(
                        height: height(8),
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            "assets/img/car-seat.svg",
                          ),
                          SizedBox(
                            width: width(6),
                          ),
                          CustomText(
                              color: rentxcontext.theme.customTheme.headline3,
                              fontSize: width(12),
                              text:
                                  "${model.getProperty(CarPropertyType.seats)?.value ?? '-'} Seats"),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: width(96),
                  height: height(94),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: model.rentalImages![0].url!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: height(10),
            ),
            const Divider(
              thickness: 1.4,
            ),
            Row(
              children: [
                PriceTag(
                  color: rentxcontext.theme.customTheme.primary,
                  fontSize: width(14),
                  fontWeight: FontWeight.w600,
                  price: model.price!,
                ),
                const Spacer(),
                Row(
                  children: [
                    CustomText(
                      color: rentxcontext.theme.customTheme.headline2,
                      fontSize: width(12),
                      text: "View Details",
                      textDecoration: TextDecoration.underline,
                    ),
                    SizedBox(
                      width: width(8),
                    ),
                    SvgPicture.asset(
                      "assets/img/arrow-left.svg",
                      color: rentxcontext.theme.customTheme.headline2,
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
