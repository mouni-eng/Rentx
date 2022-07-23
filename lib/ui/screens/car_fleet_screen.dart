import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rentx/constants.dart';
import 'package:rentx/models/car.dart';
import 'package:rentx/size_config.dart';
import 'package:rentx/ui/base_widget.dart';
import 'package:rentx/ui/components/custom_button.dart';
import 'package:rentx/ui/components/custom_text.dart';
import 'package:rentx/ui/components/expandable_text.dart';
import 'package:rentx/ui/components/price_tag.dart';
import 'package:rentx/ui/components/custom_table_calendar.dart';
import 'package:rentx/ui/screens/car_listing_screens/car_listing_screen.dart';
import 'package:rentx/view_models/car_fleet_cubit/cubit.dart';
import 'package:rentx/view_models/car_fleet_cubit/states.dart';
import 'car_listing_screens/car_listing_screen.dart';

class CarFleetScreen extends StatelessWidget {
  const CarFleetScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RentXWidget(
        builder: (rentxcontext) => BlocConsumer<CarFleetCubit, CarFleetStates>(
            listener: (context, state) {},
            builder: (context, state) {
              CarFleetCubit cubit = CarFleetCubit.get(context);
              return Scaffold(
                body: SafeArea(
                  child: ConditionalBuilder(
                    condition: state is! GetCarFleetLoadingStae,
                    builder: (context) => SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: width(10),
                          vertical: height(16),
                        ),
                        child: Column(
                          children: [
                            CarouselSlider(
                              items: List.generate(
                                cubit.rentalDetailsResult!.images!.length,
                                (index) => Stack(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: height(337),
                                      margin: EdgeInsets.symmetric(
                                        horizontal: width(5),
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          child: CachedNetworkImage(
                                            imageUrl: cubit.rentalDetailsResult!
                                                    .images![index].url ??
                                                "https://th.bing.com/th/id/R.198adcdf1eb35cdee4f2172280d979b3?rik=6PS%2biiPHLV%2bSyw&pid=ImgRaw&r=0",
                                            fit: BoxFit.cover,
                                          )),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: width(16),
                                        vertical: height(16),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          ImageCustomButton(
                                            img: "assets/img/arrow.svg",
                                            rentxcontext: rentxcontext,
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          ImageCustomButton(
                                            img: "assets/img/heart.svg",
                                            rentxcontext: rentxcontext,
                                            onTap: () {},
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              options: CarouselOptions(
                                height: height(337),
                                initialPage: 0,
                                onPageChanged: (index, reason) {
                                  cubit.changeIndex(index);
                                },
                                viewportFraction: 1,
                                enableInfiniteScroll: true,
                                disableCenter: true,
                                reverse: false,
                                autoPlay: true,
                                autoPlayInterval: const Duration(seconds: 6),
                                autoPlayAnimationDuration:
                                    const Duration(milliseconds: 800),
                                autoPlayCurve: Curves.fastOutSlowIn,
                                scrollDirection: Axis.horizontal,
                              ),
                            ),
                            SizedBox(
                              height: height(9),
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  cubit.rentalDetailsResult!.images!.length,
                                  (index) => cubit.managercarousalIndex != index
                                      ? Container(
                                          width: width(4),
                                          height: height(4),
                                          margin:
                                              EdgeInsets.only(right: width(4)),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: rentxcontext
                                                .theme.customTheme.headline4,
                                          ),
                                        )
                                      : Container(
                                          width: width(28),
                                          height: height(4),
                                          margin:
                                              EdgeInsets.only(right: width(4)),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            color: rentxcontext
                                                .theme.customTheme.primary,
                                          ),
                                        ),
                                )),
                            SizedBox(
                              height: height(8),
                            ),
                            Container(
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    color: rentxcontext
                                        .theme.customTheme.headdline,
                                    fontSize: width(16),
                                    text: cubit.rentalDetailsResult!.car!
                                        .fullName(),
                                    fontWeight: FontWeight.w600,
                                  ),
                                  PriceTag(
                                    color:
                                        rentxcontext.theme.customTheme.primary,
                                    fontSize: width(16),
                                    price:
                                        cubit.rentalDetailsResult!.price ?? 25,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: height(16),
                            ),
                            Container(
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    color: rentxcontext
                                        .theme.customTheme.headdline,
                                    fontSize: width(14),
                                    text: "Car Info",
                                  ),
                                  const Divider(
                                    thickness: 1.4,
                                  ),
                                  SizedBox(
                                    height: height(10),
                                  ),
                                  GridView.builder(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.only(
                                      right: width(100),
                                    ),
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 4 / 1,
                                      mainAxisSpacing: 10,
                                      crossAxisSpacing: 0,
                                    ),
                                    itemBuilder: (_, index) =>
                                        CarListingProperties(
                                      title: cubit.rentalDetailsResult!.car!
                                          .properties![index].value!,
                                      img: cubit.rentalDetailsResult!.car!
                                          .properties![index].type.icon!,
                                      rentxcontext: rentxcontext,
                                    ),
                                    itemCount: cubit.rentalDetailsResult!.car!
                                        .properties!.length,
                                  ),
                                  SizedBox(
                                    height: height(16),
                                  ),
                                  const Divider(
                                    thickness: 1.4,
                                  ),
                                  SizedBox(
                                    height: height(16),
                                  ),
                                  CustomText(
                                    color: rentxcontext
                                        .theme.customTheme.headdline,
                                    fontSize: width(14),
                                    text: "licensePlateNumber",
                                  ),
                                  SizedBox(
                                    height: height(6),
                                  ),
                                  CustomText(
                                    color: rentxcontext
                                        .theme.customTheme.headline3,
                                    fontSize: width(14),
                                    text: cubit.rentalDetailsResult!
                                            .licensePlate ??
                                        '-',
                                  ),
                                  SizedBox(
                                    height: height(16),
                                  ),
                                  const Divider(
                                    thickness: 1.4,
                                  ),
                                  SizedBox(
                                    height: height(16),
                                  ),
                                  CustomText(
                                    color: rentxcontext
                                        .theme.customTheme.headdline,
                                    fontSize: width(14),
                                    text: "description",
                                  ),
                                  SizedBox(
                                    height: height(6),
                                  ),
                                  ExpandableText(
                                      color: rentxcontext
                                          .theme.customTheme.headline3,
                                      text: cubit.rentalDetailsResult!.company!
                                          .description!,
                                      limit: 100),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: height(16),
                            ),
                            Container(
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomText(
                                        color: rentxcontext
                                            .theme.customTheme.headdline,
                                        fontSize: width(14),
                                        text: "bookings",
                                      ),
                                      GestureDetector(
                                        onTap: () {},
                                        child: CustomText(
                                          color: rentxcontext
                                              .theme.customTheme.onRejected,
                                          fontSize: width(14),
                                          text: "unavailable",
                                          textDecoration:
                                              TextDecoration.underline,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: height(14),
                                  ),
                                  const Divider(
                                    thickness: 1.4,
                                  ),
                                  SizedBox(
                                    height: height(14),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      BookedStatusWidget(
                                        color: rentxcontext
                                            .theme.customTheme.headdline,
                                        text: "available",
                                      ),
                                      BookedStatusWidget(
                                        color: rentxcontext
                                            .theme.customTheme.headline3,
                                        text: "unavailable",
                                      ),
                                      BookedStatusWidget(
                                        color: rentxcontext
                                            .theme.customTheme.onApprove,
                                        text: "booked",
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    height: height(400),
                                    child: CustomTableCalendar(
                                        selectedDay: cubit.selectedDay,
                                        startDay: cubit.rangeStart,
                                        endDay: cubit.rangeEnd,
                                        focusedDay: cubit.focusedDay,
                                        onChangeFormat: cubit.toggleFormat,
                                        onChangeRange: cubit.chooseDateEnd,
                                        onChangeDay: cubit.chooseDate,
                                        rangeSelectionMode:
                                            cubit.rangeSelectionMode,
                                        calendarFormat: cubit.calendarFormat),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: height(50),
                            ),
                            CustomButton(
                              fontSize: width(14),
                              function: () {},
                              background: cubit.rangeStart == null
                                  ? rentxcontext
                                      .theme.customTheme.shimmerHighlightColor
                                  : rentxcontext.theme.customTheme.primary,
                              text: "bookNow",
                            ),
                          ],
                        ),
                      ),
                    ),
                    fallback: (BuildContext context) => const Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  ),
                ),
              );
            }));
  }
}

class BookedStatusWidget extends StatelessWidget {
  const BookedStatusWidget({
    Key? key,
    required this.color,
    this.text,
  }) : super(key: key);

  final Color color;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          "assets/img/ellipse.svg",
          color: color,
        ),
        SizedBox(
          width: width(6),
        ),
        CustomText(
          color: color,
          fontSize: width(14),
          text: text!,
        ),
      ],
    );
  }
}
