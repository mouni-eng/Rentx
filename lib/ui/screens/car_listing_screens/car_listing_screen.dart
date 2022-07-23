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
import 'package:rentx/ui/components/util/smooth_carousel_indicator.dart';
import 'package:rentx/ui/screens/booking_confirmation.dart';
import 'package:rentx/ui/screens/car_listing_screens/car_listing_map.dart';
import 'package:rentx/view_models/company_cubit/cubit.dart';
import 'package:rentx/view_models/create_booking_cubit/cubit.dart';
import 'package:rentx/view_models/rental_details_cubit/cubit.dart';
import 'package:rentx/view_models/rental_details_cubit/states.dart';

import '../manger_screens/company_screen.dart';
import 'car_listing_company_card.dart';

class RentalCarListingScreen extends StatelessWidget {
  const RentalCarListingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RentXWidget(
        builder: (rentxcontext) => BlocConsumer<RentalDetailsCubit,
                RentalDetailsStates>(
            listener: (context, state) {},
            builder: (context, state) {
              RentalDetailsCubit cubit = RentalDetailsCubit.get(context);
              return Scaffold(
                body: SafeArea(
                  child: ConditionalBuilder(
                    condition: state is! GetRentalDetailsLoadingState,
                    builder: (context) => Stack(
                      children: [
                        SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: width(10),
                              vertical: height(16),
                            ),
                            child: Column(
                              children: [
                                CarouselSlider(
                                  carouselController: cubit.carouselController,
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
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              child: CachedNetworkImage(
                                                imageUrl: cubit
                                                    .rentalDetailsResult!
                                                    .images![index]
                                                    .url!,
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
                                    autoPlayInterval:
                                        const Duration(seconds: 6),
                                    autoPlayAnimationDuration:
                                        const Duration(milliseconds: 800),
                                    autoPlayCurve: Curves.fastOutSlowIn,
                                    scrollDirection: Axis.horizontal,
                                  ),
                                ),
                                SizedBox(
                                  height: height(9),
                                ),
                                SmoothCarouselIndicator(
                                  currentPage: cubit.carousalIndex,
                                  count:
                                      cubit.rentalDetailsResult!.images!.length,
                                  initialPage: 0,
                                ),
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
                                    color: rentxcontext
                                        .theme.customTheme.onPrimary,
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
                                          Expanded(
                                            child: CustomText(
                                              color: rentxcontext
                                                  .theme.customTheme.headdline,
                                              fontSize: width(16),
                                              text: cubit.rentalDetailsResult!
                                                  .car!.make!,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          PriceTag(
                                            color: rentxcontext
                                                .theme.customTheme.headdline,
                                            fontSize: width(16),
                                            price: cubit
                                                .rentalDetailsResult!.price!,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          CustomText(
                                              color: rentxcontext
                                                  .theme.customTheme.headline2,
                                              fontSize: width(12),
                                              text: cubit.rentalDetailsResult!
                                                  .car!.model!),
                                        ],
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
                                    color: rentxcontext
                                        .theme.customTheme.onPrimary,
                                    boxShadow: [
                                      boxShadow,
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        color: rentxcontext
                                            .theme.customTheme.headdline,
                                        fontSize: width(14),
                                        text: "carInfo",
                                      ),
                                      const Divider(
                                        thickness: 1.4,
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
                                        itemCount: cubit.rentalDetailsResult!
                                            .car!.properties!.length,
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
                                          text: cubit.rentalDetailsResult!
                                                  .company!.description ??
                                              '-',
                                          limit: 100),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: height(16),
                                ),
                                GestureDetector(
                                    onTap: () {
                                      CompanyCubit.get(context).getCompanyInfo(
                                          cubit.rentalDetailsResult!.company!
                                              .id!);
                                      rentxcontext.route(
                                          (p0) => const CompanyDetailsScreen());
                                    },
                                    child: CompanyCard(
                                        company: cubit
                                            .rentalDetailsResult!.company!)),
                                SizedBox(
                                  height: height(16),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    cubit.launchMaps();
                                  },
                                  child: CarListingMap(
                                      company:
                                          cubit.rentalDetailsResult!.company!,
                                      label: 'whereYouCanFindUs',
                                      mapController: cubit.mapController),
                                ),
                                SizedBox(
                                  height: height(80),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Material(
                            elevation: 40,
                            child: Container(
                              height: height(80),
                              padding: EdgeInsets.symmetric(
                                horizontal: width(24),
                                vertical: height(8),
                              ),
                              color: rentxcontext.theme.customTheme.onPrimary,
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    "assets/img/bank-transfer.svg",
                                    color: rentxcontext
                                        .theme.customTheme.headdline,
                                  ),
                                  SizedBox(
                                    width: width(13),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                            color: rentxcontext
                                                .theme.customTheme.headline3,
                                            fontSize: width(16),
                                            text: "1 Apr - 5 Apr"),
                                        PriceTag(
                                          color: rentxcontext
                                              .theme.customTheme.headdline,
                                          fontSize: width(16),
                                          price:
                                              cubit.rentalDetailsResult!.price!,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ],
                                    ),
                                  ),
                                  CustomButton(
                                    btnWidth: width(130),
                                    fontSize: width(14),
                                    isUpperCase: false,
                                    function: () {
                                      CreateBookingCubit.get(context)
                                          .init(cubit.rentalDetailsResult!);
                                      rentxcontext.route((p0) =>
                                          const BookingConfirmationScreen());
                                    },
                                    text: "bookNow",
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
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

class CarListingProperties extends StatelessWidget {
  const CarListingProperties({
    Key? key,
    required this.img,
    required this.title,
    required this.rentxcontext,
  }) : super(key: key);

  final String img, title;
  final RentXContext rentxcontext;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          img,
          color: rentxcontext.theme.customTheme.primary,
        ),
        SizedBox(
          width: width(12),
        ),
        CustomText(
            color: rentxcontext.theme.customTheme.headdline,
            fontSize: width(14),
            text: title),
      ],
    );
  }
}

class ImageCustomButton extends StatelessWidget {
  const ImageCustomButton({
    Key? key,
    required this.img,
    required this.rentxcontext,
    required this.onTap,
  }) : super(key: key);

  final String img;
  final RentXContext rentxcontext;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width(36),
        height: height(36),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: rentxcontext.theme.customTheme.onPrimary,
          boxShadow: [
            boxShadow,
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width(8),
            vertical: height(8),
          ),
          child: SvgPicture.asset(
            img,
          ),
        ),
      ),
    );
  }
}
