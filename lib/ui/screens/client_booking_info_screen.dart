import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rentx/infrastructure/utils.dart';
import 'package:rentx/models/booking_model.dart';
import 'package:rentx/size_config.dart';
import 'package:rentx/ui/base_widget.dart';
import 'package:rentx/ui/components/badge_widget.dart';
import 'package:rentx/ui/components/custom_text.dart';
import 'package:rentx/ui/components/price_tag.dart';
import 'package:rentx/ui/components/rentx_cached_image.dart';
import 'package:rentx/ui/screens/car_listing_screens/car_listing_map.dart';
import 'package:rentx/ui/screens/layout_screens/profile_screen.dart';
import 'package:rentx/ui/widgets/map/rentx_map_card.dart';
import 'package:rentx/view_models/client_booking_details_cubit/cubit.dart';
import 'package:rentx/view_models/client_booking_details_cubit/states.dart';

class ClientBookingInfoScreen extends StatelessWidget {
  const ClientBookingInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RentXWidget(
      builder: (rentxcontext) => BlocConsumer<ClientBookingDetailsCubit,
              ClientBookingDetailsStates>(
          listener: (context, state) {},
          builder: (context, state) {
            ClientBookingDetailsCubit cubit =
                ClientBookingDetailsCubit.get(context);
            return Scaffold(
              body: ConditionalBuilder(
                condition: state is! BookingLoadingState,
                builder: (context) => SafeArea(
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
                                width: width(16),
                              ),
                              CustomText(
                                color: rentxcontext.theme.customTheme.headdline,
                                fontSize: width(22),
                                text: "bookingConfirmation",
                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height(24),
                          ),
                          Row(children: [
                            Container(
                              width: width(104),
                              height: height(104),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: RentXCachedImage(
                                  url: cubit
                                      .userBookingDetails!.featuredImageUrl!,
                                  boxFit: BoxFit.fill,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: width(16),
                            ),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  color:
                                      rentxcontext.theme.customTheme.headdline,
                                  fontSize: width(18),
                                  text: cubit.userBookingDetails!.car!.fullName,
                                  fontWeight: FontWeight.w600,
                                ),
                                CustomText(
                                  color:
                                      rentxcontext.theme.customTheme.headline3,
                                  fontSize: width(14),
                                  text:
                                      cubit.userBookingDetails!.company!.name!,
                                ),
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/img/location.svg",
                                      color: rentxcontext
                                          .theme.customTheme.primary,
                                    ),
                                    SizedBox(
                                      width: width(7),
                                    ),
                                    Expanded(
                                        child: CustomText(
                                      color: rentxcontext
                                          .theme.customTheme.primary,
                                      fontSize: width(12),
                                      text: cubit
                                          .userBookingDetails!.company!.address!
                                          .fullAddress(),
                                    )),
                                  ],
                                ),
                              ],
                            )),
                          ]),
                          SizedBox(
                            height: height(18),
                          ),
                          const Divider(
                            thickness: 1.4,
                          ),
                          SizedBox(
                            height: height(18),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      color: rentxcontext
                                          .theme.customTheme.headdline,
                                      fontSize: width(18),
                                      text: "dates",
                                      fontWeight: FontWeight.w600,
                                    ),
                                    SizedBox(
                                      height: height(8),
                                    ),
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          "assets/img/calendar.svg",
                                          color: rentxcontext
                                              .theme.customTheme.headline2,
                                        ),
                                        SizedBox(
                                          width: width(7),
                                        ),
                                        CustomText(
                                            color: rentxcontext
                                                .theme.customTheme.headline2,
                                            fontSize: width(12),
                                            text: DateUtil.displayRange(
                                                cubit.userBookingDetails!
                                                    .fromDate!,
                                                cubit.userBookingDetails!
                                                    .toDate!)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height(18),
                          ),
                          const Divider(
                            thickness: 1.4,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      color: rentxcontext
                                          .theme.customTheme.headdline,
                                      fontSize: width(18),
                                      text: "status",
                                      fontWeight: FontWeight.w600,
                                    ),
                                    SizedBox(
                                      height: height(8),
                                    ),
                                    Row(
                                      children: [
                                        CustomRectBadge(
                                            text: cubit.userBookingDetails!
                                                .status!.name,
                                            color: cubit
                                                .userBookingDetails!.status!
                                                .getTextColor(rentxcontext),
                                            bgColor: cubit
                                                .userBookingDetails!.status!
                                                .getBadgeColor(rentxcontext)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height(18),
                          ),
                          const Divider(
                            thickness: 1.4,
                          ),
                          SizedBox(
                            height: height(18),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                color: rentxcontext.theme.customTheme.headdline,
                                fontSize: width(18),
                                text: "priceDetails",
                                fontWeight: FontWeight.w600,
                              ),
                              SizedBox(
                                height: height(14),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                    color: rentxcontext
                                        .theme.customTheme.headline3,
                                    fontSize: width(16),
                                    text: "price",
                                  ),
                                  PriceTag(
                                    color: rentxcontext
                                        .theme.customTheme.headline3,
                                    fontSize: width(16),
                                    ltr: false,
                                    price:
                                        cubit.userBookingDetails!.pricePerDay!,
                                    suffix:
                                        " x ${cubit.userBookingDetails!.toDate!.difference(cubit.userBookingDetails!.fromDate!).inDays + 1} ${rentxcontext.translate('Days')}",
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: height(8),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                    color: rentxcontext
                                        .theme.customTheme.headline3,
                                    fontSize: width(16),
                                    text: "serviceFees",
                                  ),
                                  PriceTag(
                                    color: rentxcontext
                                        .theme.customTheme.headline3,
                                    fontSize: width(16),
                                    price: 0,
                                    showPerDay: false,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: height(8),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                    color: rentxcontext
                                        .theme.customTheme.headdline,
                                    fontSize: width(16),
                                    text: "totalPrice",
                                    fontWeight: FontWeight.w600,
                                  ),
                                  PriceTag(
                                    color:
                                        rentxcontext.theme.customTheme.primary,
                                    fontSize: width(16),
                                    price:
                                        cubit.userBookingDetails!.totalPrice!,
                                    fontWeight: FontWeight.w600,
                                    showPerDay: false,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height(18),
                          ),
                          const Divider(
                            thickness: 1.4,
                          ),
                          SizedBox(
                            height: height(18),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                color: rentxcontext.theme.customTheme.headdline,
                                fontSize: width(18),
                                text: "paymentMethod",
                                fontWeight: FontWeight.w600,
                              ),
                              SizedBox(
                                height: height(10),
                              ),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    "assets/img/bank-transfer.svg",
                                    color:
                                        rentxcontext.theme.customTheme.primary,
                                  ),
                                  SizedBox(
                                    width: width(10),
                                  ),
                                  CustomText(
                                    color: rentxcontext
                                        .theme.customTheme.headline3,
                                    fontSize: width(16),
                                    text: "cashOnDelivery",
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height(18),
                          ),
                          const Divider(
                            thickness: 1.4,
                          ),
                          SizedBox(
                            height: height(18),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                color: rentxcontext.theme.customTheme.headdline,
                                fontSize: width(18),
                                text: "Cancellation Policy",
                                fontWeight: FontWeight.w600,
                              ),
                              SizedBox(
                                height: height(10),
                              ),
                              CustomText(
                                color: rentxcontext.theme.customTheme.headline3,
                                fontSize: width(16),
                                maxlines: 20,
                                text:
                                    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,",
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height(18),
                          ),
                          const Divider(
                            thickness: 1.4,
                          ),
                          SizedBox(
                            height: height(18),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                color: rentxcontext.theme.customTheme.headdline,
                                fontSize: width(18),
                                text: "pickupLocation",
                                fontWeight: FontWeight.w600,
                              ),
                              SizedBox(
                                height: height(10),
                              ),
                              CarListingMap(
                                  padding: EdgeInsets.only(
                                      left: width(5), right: width(20)),
                                  company: cubit.userBookingDetails!.company!,
                                  mapController: RentXMapController()),
                            ],
                          ),
                          SizedBox(
                            height: height(30),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                fallback: (context) => const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              ),
            );
          }),
    );
  }
}
