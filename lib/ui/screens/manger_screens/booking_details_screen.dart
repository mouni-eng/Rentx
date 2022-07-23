import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rentx/infrastructure/utils.dart';
import 'package:rentx/models/booking_model.dart';
import 'package:rentx/size_config.dart';
import 'package:rentx/ui/base_widget.dart';
import 'package:rentx/ui/components/custom_button.dart';
import 'package:rentx/ui/components/custom_text.dart';
import 'package:rentx/ui/components/price_tag.dart';
import 'package:rentx/ui/components/rentx_circle_image.dart';
import 'package:rentx/ui/screens/layout_screens/profile_screen.dart';
import 'package:rentx/ui/screens/manger_screens/booking_screen.dart';
import 'package:rentx/ui/utils.dart';
import 'package:rentx/view_models/booking_cubit/cubit.dart';

class BookingDetailsScreen extends StatelessWidget {
  const BookingDetailsScreen({Key? key, required this.model}) : super(key: key);

  final CompanyBooking model;

  @override
  Widget build(BuildContext context) {
    return RentXWidget(
      builder: (rentxcontext) => Scaffold(
          body: SafeArea(
              child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width(16),
            vertical: height(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  BackButtonWidget(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    rentxcontext: rentxcontext,
                  ),
                  SizedBox(
                    width: width(16),
                  ),
                  CustomText(
                    color: rentxcontext.theme.customTheme.headdline,
                    fontSize: width(22),
                    text: "Booking Details",
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
              SizedBox(
                height: height(30),
              ),
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                RentXCircleImage(
                  imageSrc: model.user!.imageUrl ?? model.user!.imageUrl,
                  avatarLetters: NameUtil.getInitials(
                      model.user?.firstName, model.user?.lastName),
                ),
                SizedBox(
                  width: width(14),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      color: rentxcontext.theme.customTheme.headdline,
                      fontSize: width(16),
                      text: model.user!.fullName,
                      fontWeight: FontWeight.w600,
                    ),
                    CustomText(
                      color: rentxcontext.theme.customTheme.headline3,
                      fontSize: width(14),
                      text: model.user!.email ?? "estherhoward@gmail.com",
                    ),
                    SizedBox(
                      height: height(10),
                    ),
                    Row(
                      children: [
                        SvgPicture.asset("assets/img/Calling.svg"),
                        SizedBox(
                          width: width(8),
                        ),
                        CustomText(
                          color: rentxcontext.theme.customTheme.primary,
                          fontSize: width(12),
                          text: model.user!.phoneNumber ?? "(704) 555-0127",
                        ),
                      ],
                    ),
                  ],
                ),
              ]),
              SizedBox(
                height: height(10),
              ),
              const Divider(
                thickness: 1.3,
              ),
              SizedBox(
                height: height(10),
              ),
              CustomText(
                color: rentxcontext.theme.customTheme.headdline,
                fontSize: width(18),
                text: model.car!.fullName,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(
                height: height(6),
              ),
              CustomText(
                color: rentxcontext.theme.customTheme.headline3,
                fontSize: width(14),
                text: BookingCubit.get(context)
                    .bookingManagerModel!
                    .company!
                    .name!,
              ),
              SizedBox(
                height: height(10),
              ),
              const Divider(
                thickness: 1.3,
              ),
              SizedBox(
                height: height(10),
              ),
              CustomText(
                color: rentxcontext.theme.customTheme.headdline,
                fontSize: width(18),
                text: "Dates",
                fontWeight: FontWeight.w600,
              ),
              SizedBox(
                height: height(6),
              ),
              Row(children: [
                SvgPicture.asset("assets/img/calendar.svg"),
                SizedBox(
                  width: width(8),
                ),
                CustomText(
                  color: rentxcontext.theme.customTheme.headline3,
                  fontSize: width(14),
                  text: DateUtil.displayRange(model.fromDate!, model.toDate!),
                ),
              ]),
              SizedBox(
                height: height(10),
              ),
              const Divider(
                thickness: 1.3,
              ),
              SizedBox(
                height: height(10),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    color: rentxcontext.theme.customTheme.headdline,
                    fontSize: width(18),
                    text: "Price Details",
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(
                    height: height(14),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        color: rentxcontext.theme.customTheme.headline3,
                        fontSize: width(16),
                        text: "Price",
                      ),
                      Row(
                        children: [
                          PriceTag(
                            color: rentxcontext.theme.customTheme.headline3,
                            fontSize: width(16),
                            price: model.pricePerDay!,
                          ),
                          CustomText(
                            color: rentxcontext.theme.customTheme.headline3,
                            fontSize: width(16),
                            text: DateUtil.displayDiffrence(
                                model.fromDate!, model.toDate!),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height(8),
                  ),
                  Column(
                    children: List.generate(
                      model.fees!.length,
                      (index) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            color: rentxcontext.theme.customTheme.headline3,
                            fontSize: width(16),
                            text: model.fees![index].type.toString(),
                          ),
                          PriceTag(
                            color: rentxcontext.theme.customTheme.headline3,
                            fontSize: width(16),
                            showPerDay: false,
                            price: model.fees![index].value!,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height(8),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        color: rentxcontext.theme.customTheme.headdline,
                        fontSize: width(16),
                        text: "Total Price (USD)",
                        fontWeight: FontWeight.w600,
                      ),
                      PriceTag(
                        color: rentxcontext.theme.customTheme.primary,
                        fontSize: width(16),
                        showPerDay: false,
                        price: model.totalPrice!,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: height(10),
              ),
              const Divider(
                thickness: 1.3,
              ),
              SizedBox(
                height: height(10),
              ),
              SizedBox(
                height: height(80),
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      radius: 8,
                      background: rentxcontext.theme.customTheme.onRejected,
                      text: "reject",
                      function: () {
                        showDialog(
                          context: context,
                          builder: (context) => RejectionDialog(
                            bookings: model,
                          ),
                        );
                      },
                      fontSize: width(12),
                      isUpperCase: false,
                    ),
                  ),
                  SizedBox(
                    width: width(24),
                  ),
                  Expanded(
                    child: CustomButton(
                      radius: 8,
                      background: rentxcontext.theme.customTheme.primary,
                      text: "approve",
                      function: () {
                        showDialog(
                          context: context,
                          builder: (context) => ApproveDialog(
                            bookings: model,
                          ),
                        );
                      },
                      fontSize: width(12),
                      isUpperCase: false,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ))),
    );
  }
}
