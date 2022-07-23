import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rentx/infrastructure/utils.dart';
import 'package:rentx/models/booking_model.dart';
import 'package:rentx/size_config.dart';
import 'package:rentx/ui/base_widget.dart';
import 'package:rentx/ui/components/badge_widget.dart';
import 'package:rentx/ui/components/custom_text.dart';
import 'package:rentx/ui/components/header_widget.dart';
import 'package:rentx/ui/components/price_tag.dart';
import 'package:rentx/ui/screens/layout_screens/profile_screen.dart';
import 'package:rentx/view_models/client_booking_details_cubit/cubit.dart';
import 'package:rentx/view_models/client_booking_list_cubit/cubit.dart';
import 'package:rentx/view_models/client_booking_list_cubit/states.dart';
import 'package:rentx/view_models/home_cubit/cubit.dart';

import 'client_booking_info_screen.dart';

class ClientBookingListScreen extends StatelessWidget {
  const ClientBookingListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return RentXWidget(
      builder: (rentxcontext) =>
          BlocConsumer<ClientBookingsCubit, ClientBookingStates>(
              listener: (context, state) => {},
              builder: (context, state) {
                ClientBookingsCubit cubit = ClientBookingsCubit.get(context);
                return Scaffold(
                  body: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: width(16),
                        vertical: height(16),
                      ),
                      child: ConditionalBuilder(
                        condition: state is! BookingsLoadingState,
                        builder: (context) => SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  BackButtonWidget(
                                    rentxcontext: rentxcontext,
                                    onTap: () => HomeCubit.get(context)
                                        .chooseBottomNavIndex(0),
                                  ),
                                  SizedBox(
                                    width: width(16),
                                  ),
                                  CustomText(
                                    color: rentxcontext
                                        .theme.customTheme.headdline,
                                    fontSize: width(22),
                                    text: "bookingList",
                                    fontWeight: FontWeight.w600,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: height(25),
                              ),
                              HeaderWidget(
                                title: "activeBookings",
                                rawText:
                                    ' (${NumberUtil.padNumber(cubit.availableBookings.length, length: 2)})',
                                onTap: () => cubit.toggleViewAllActive(),
                                btnText: cubit.toggleShowAllActive
                                    ? 'viewLess'
                                    : 'viewMore',
                              ),
                              SizedBox(
                                height: height(16),
                              ),
                              ...cubit
                                  .getActive()
                                  .map((e) => ClientBookingWidget(
                                      userBooking: e,
                                      onTap: () {
                                        ClientBookingDetailsCubit.get(context)
                                            .getBooking(e);
                                        rentxcontext.route((p0) =>
                                            const ClientBookingInfoScreen());
                                      }))
                                  .toList(),
                              SizedBox(
                                height: height(24),
                              ),
                              HeaderWidget(
                                title: "previousBookings",
                                rawText:
                                    ' (${NumberUtil.padNumber(cubit.pastBookings.length, length: 2)})',
                                btnText: cubit.toggleShowAllPrevious
                                    ? 'viewLess'
                                    : 'viewMore',
                                onTap: () => cubit.toggleViewAllPrevious(),
                              ),
                              SizedBox(
                                height: height(16),
                              ),
                              ...cubit
                                  .getPast()
                                  .map((e) => ClientBookingWidget(
                                        userBooking: e,
                                        onTap: () {
                                          ClientBookingDetailsCubit.get(
                                                  rentxcontext.context)
                                              .getBooking(e);
                                          rentxcontext.route((p0) =>
                                              const ClientBookingInfoScreen());
                                        },
                                      ))
                                  .toList(),
                            ],
                          ),
                        ),
                        fallback: (ctx) => const Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      ),
                    ),
                  ),
                );
              }),
    );
  }
}

class ClientBookingWidget extends StatelessWidget {
  const ClientBookingWidget({Key? key, required this.userBooking, this.onTap})
      : super(key: key);

  final UserBooking userBooking;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return RentXWidget(
        builder: (rentxcontext) => GestureDetector(
              onTap: onTap,
              child: Container(
                  width: double.infinity,
                  height: height(180),
                  padding: EdgeInsets.symmetric(
                    horizontal: width(16),
                    vertical: height(14),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: rentxcontext.theme.customTheme.onPrimary,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF000000)
                            .withOpacity(0.06), //color of shadow
                        //spread radius
                        blurRadius: width(30), // blur radius
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: width(96),
                            height: height(94),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.black.withOpacity(0.9)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl: userBooking.featuredImageUrl!,
                                fit: BoxFit.cover,
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
                                color: rentxcontext.theme.customTheme.headdline,
                                fontSize: width(16),
                                fontWeight: FontWeight.w600,
                                text: userBooking.car!.fullName,
                              ),
                              CustomText(
                                color: rentxcontext.theme.customTheme.headline3,
                                fontSize: width(14),
                                text: userBooking.companyName!,
                              ),
                              PriceTag(
                                  color: rentxcontext.theme.customTheme.primary,
                                  fontSize: width(16),
                                  fontWeight: FontWeight.w600,
                                  price: userBooking.totalPrice!,
                                  showPerDay: false),
                            ],
                          ))
                        ],
                      ),
                      SizedBox(
                        height: height(5),
                      ),
                      const Divider(
                        thickness: 1,
                      ),
                      Row(
                        children: [
                          SvgPicture.asset("assets/img/calendar.svg"),
                          SizedBox(
                            width: width(8),
                          ),
                          CustomText(
                            color: rentxcontext.theme.customTheme.headline2,
                            fontSize: width(14),
                            text: DateUtil.displayRange(
                                userBooking.fromDate!, userBooking.toDate!),
                          ),
                          const Spacer(),
                          modelToWidget<BookingStatus>(
                              userBooking.status,
                              (status) => CustomRectBadge(
                                    text: status.name.toLowerCase(),
                                    color: status.getTextColor(rentxcontext),
                                    bgColor: status.getBadgeColor(rentxcontext),
                                    badgeWidth: 75,
                                  ))!
                        ],
                      )
                    ],
                  )),
            ));
  }
}
