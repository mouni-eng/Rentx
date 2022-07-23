import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rentx/services/alert_service.dart';
import 'package:rentx/size_config.dart';
import 'package:rentx/ui/base_widget.dart';
import 'package:rentx/ui/components/custom_button.dart';
import 'package:rentx/ui/components/custom_text.dart';
import 'package:rentx/ui/components/rentx_cached_image.dart';
import 'package:rentx/ui/screens/auth_screens/logIn_screen.dart';
import 'package:rentx/ui/screens/auth_screens/user_registration_screens/user_registration.dart';
import 'package:rentx/ui/screens/car_listing_screens/create/steps/set_properties.dart';
import 'package:rentx/ui/screens/completed_screen.dart';
import 'package:rentx/ui/screens/layout_screens/layout_screen.dart';
import 'package:rentx/ui/screens/layout_screens/profile_screen.dart';
import 'package:rentx/view_models/create_booking_cubit/cubit.dart';
import 'package:rentx/view_models/create_booking_cubit/states.dart';
import 'package:rentx/view_models/home_cubit/cubit.dart';

class BookingConfirmationScreen extends StatelessWidget {
  const BookingConfirmationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RentXWidget(
        builder: (rentxcontext) =>
            BlocConsumer<CreateBookingCubit, CreateBookingStates>(
                listener: (context, state) {
              if (state is BookingCreatedState) {
                rentxcontext.route((context) => CompletedScreen(
                    title: 'booking.created.title',
                    text: 'booking.created.desc',
                    onBtnClick: () {
                      HomeCubit.get(context).chooseBottomNavIndex(2);
                      rentxcontext.route((p0) => const LayoutScreen());
                    }));
              }
              if (state is BookingCreationError) {
                AlertService.showSnackbarAlert(
                    state.error, rentxcontext, SnackbarType.error);
              }
            }, builder: (context, state) {
              CreateBookingCubit cubit = CreateBookingCubit.get(context);
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
                                width: width(16),
                              ),
                              CustomText(
                                color: rentxcontext.theme.customTheme.headdline,
                                fontSize: width(22),
                                text: 'bookingConfirmation',
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
                                  url: cubit.model!.images!
                                      .firstWhere(
                                          (element) => element.isFeatured!)
                                      .url!,
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
                                  text: cubit.model!.car!.fullName(),
                                  fontWeight: FontWeight.w600,
                                ),
                                CustomText(
                                  color:
                                      rentxcontext.theme.customTheme.headline3,
                                  fontSize: width(14),
                                  text: cubit.model!.company!.name!,
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
                                            text: cubit.model!.company!.address!
                                                .fullAddress())),
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
                                      text: "Dates",
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
                                            text: "20 - 24th April 2021"),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              CustomText(
                                color: rentxcontext.theme.customTheme.primary,
                                fontSize: width(16),
                                textDecoration: TextDecoration.underline,
                                text: "Edit",
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
                                text: "Price Details",
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
                                    text: "Price",
                                  ),
                                  CustomText(
                                    color: rentxcontext
                                        .theme.customTheme.headline3,
                                    fontSize: width(16),
                                    text: "25\$/Day x 5 Days",
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
                                    text: "Service Fees",
                                  ),
                                  CustomText(
                                    color: rentxcontext
                                        .theme.customTheme.headline3,
                                    fontSize: width(16),
                                    text: "\$0",
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
                                    text: "Total Price (USD)",
                                    fontWeight: FontWeight.w600,
                                  ),
                                  CustomText(
                                    color:
                                        rentxcontext.theme.customTheme.primary,
                                    fontSize: width(16),
                                    text: "\$75",
                                    fontWeight: FontWeight.w600,
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
                                text: "Payment Method",
                                fontWeight: FontWeight.w600,
                              ),
                              SizedBox(
                                height: height(10),
                              ),
                              Row(
                                children: [
                                  Radio(
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    visualDensity: VisualDensity.compact,
                                    value: 0,
                                    groupValue: 0,
                                    onChanged: (value) {},
                                  ),
                                  CustomText(
                                    color: rentxcontext
                                        .theme.customTheme.headline3,
                                    fontSize: width(16),
                                    text: "Cash on Delivery",
                                  ),
                                  const Spacer(),
                                  SvgPicture.asset(
                                    "assets/img/bank-transfer.svg",
                                    color:
                                        rentxcontext.theme.customTheme.primary,
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
                            height: height(24),
                          ),
                          RentXAuthenticatedWidget(
                              predicate: (role, authenticated) =>
                                  !authenticated,
                              builder: (rentXContext) =>
                                  _userInfoForm(rentXContext, cubit),
                              fallback: (ctx) => const SizedBox()),
                          CustomButton(
                            showLoader: state is BookingCreationLoadingState,
                            fontSize: width(16),
                            isUpperCase: false,
                            function: () {
                              cubit.createBooking();
                            },
                            text: 'confirmBooking',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }));
  }

  Widget _userInfoForm(
      final RentXContext rentxcontext, final CreateBookingCubit cubit) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: height(18),
        ),
        RichText(
          maxLines: 20,
          text: TextSpan(
              text: rentxcontext.translate('signIn'),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  rentxcontext.route((p0) => LogInScreen());
                },
              style: TextStyle(
                fontSize: width(14),
                color: rentxcontext.theme.customTheme.primary,
                fontWeight: FontWeight.w600,
              ),
              children: <TextSpan>[
                TextSpan(
                  text:
                      rentxcontext.translate('bookingConfirmation.user.part1'),
                  style: TextStyle(
                    fontSize: width(14),
                    color: rentxcontext.theme.customTheme.headline3,
                  ),
                ),
                TextSpan(
                  text: ' ' + rentxcontext.translate('register'),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      rentxcontext
                          .route((p0) => const UserRegistrationScreen());
                    },
                  style: TextStyle(
                    fontSize: width(14),
                    color: rentxcontext.theme.customTheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text:
                      rentxcontext.translate('bookingConfirmation.user.part2'),
                  style: TextStyle(
                    fontSize: width(14),
                    color: rentxcontext.theme.customTheme.headline3,
                  ),
                ),
              ]),
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
        CustomText(
          color: rentxcontext.theme.customTheme.headdline,
          fontSize: width(18),
          text: "Enter your details",
          fontWeight: FontWeight.w600,
        ),
        SizedBox(
          height: height(16),
        ),
        PropertiesWidget(
          name: "Name*",
          onChange: (value) {
            cubit.changeName(value);
          },
        ),
        PropertiesWidget(
          name: "Surname*",
          onChange: (value) {
            cubit.changeSurName(value);
          },
        ),
        PropertiesWidget(
          name: "Email Address*",
          onChange: (value) {
            cubit.changeEmail(value);
          },
        ),
        PropertiesWidget(
          name: "Confirm Email Address*",
          onChange: (value) {
            cubit.changeConfirmEmail(value);
          },
        ),
        PropertiesWidget(
          name: "Phone Number (Optional)",
          onChange: (value) {
            cubit.changePhoneNumber(value);
          },
        ),
      ],
    );
  }
}
