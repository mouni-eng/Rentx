import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rentx/constants.dart';
import 'package:rentx/helper/validation.dart';
import 'package:rentx/infrastructure/utils.dart';
import 'package:rentx/models/booking_model.dart';
import 'package:rentx/size_config.dart';
import 'package:rentx/ui/base_widget.dart';
import 'package:rentx/ui/components/company_info_badge.dart';
import 'package:rentx/ui/components/custom_button.dart';
import 'package:rentx/ui/components/custom_dropdown_search.dart';
import 'package:rentx/ui/components/custom_text.dart';
import 'package:rentx/ui/components/dot_badge.dart';
import 'package:rentx/ui/components/price_tag.dart';
import 'package:rentx/ui/components/rentx_circle_image.dart';
import 'package:rentx/ui/screens/car_listing_screens/create/steps/set_properties.dart';
import 'package:rentx/ui/screens/manger_screens/booking_details_screen.dart';
import 'package:rentx/view_models/booking_cubit/cubit.dart';
import 'package:rentx/view_models/booking_cubit/states.dart';

class BookingManagerScreen extends StatelessWidget {
  const BookingManagerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RentXWidget(
        builder: (rentxcontext) => BlocConsumer<BookingCubit, BookingStates>(
            listener: (context, state) {},
            builder: (context, state) {
              BookingCubit cubit = BookingCubit.get(context);
              return Scaffold(
                body: SafeArea(
                  child: ConditionalBuilder(
                    condition: state is! GetBookingDataLoadingState,
                    fallback: (context) => const Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                    builder: (context) => SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: width(16),
                          vertical: height(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              color: rentxcontext.theme.customTheme.headdline,
                              fontSize: width(24),
                              text: "Booking List",
                              fontWeight: FontWeight.w600,
                            ),
                            SizedBox(
                              height: height(24),
                            ),
                            CompanyInfoBadge(
                                companyName:
                                    cubit.bookingManagerModel!.company!.name!,
                                fullAddress: cubit
                                    .bookingManagerModel!.company!.address!
                                    .fullAddress()),
                            SizedBox(
                              height: height(16),
                            ),
                            ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount:
                                  cubit.bookingManagerModel!.bookings!.length,
                              separatorBuilder: (context, index) => SizedBox(
                                height: height(10),
                              ),
                              itemBuilder: (context, index) =>
                                  CustomBookingScreenCard(
                                      bookings: cubit.bookingManagerModel!
                                          .bookings![index]),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }));
  }
}

class CustomBookingScreenCard extends StatelessWidget {
  const CustomBookingScreenCard({
    Key? key,
    required this.bookings,
  }) : super(key: key);

  final CompanyBooking bookings;

  @override
  Widget build(BuildContext context) {
    return RentXWidget(
      builder: (rentxcontext) => BlocConsumer<BookingCubit, BookingStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingDetailsScreen(
                      model: bookings,
                    ),
                  ),
                );
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
                  boxShadow: [boxShadow],
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RentXCircleImage(
                          imageSrc: bookings.user!.imageUrl ??
                              "https://th.bing.com/th/id/R.198adcdf1eb35cdee4f2172280d979b3?rik=6PS%2biiPHLV%2bSyw&pid=ImgRaw&r=0",
                          avatarLetters: NameUtil.getInitials(
                              bookings.user?.firstName,
                              bookings.user?.lastName),
                        ),
                        SizedBox(
                          width: width(14),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomText(
                                      color: rentxcontext
                                          .theme.customTheme.headdline,
                                      fontSize: width(16),
                                      text: bookings.user!.fullName,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  modelToWidget<BookingStatus>(
                                          bookings.status,
                                          (status) => DotBadge(
                                              title: status.name,
                                              color: status.getTextColor(
                                                  rentxcontext))) ??
                                      const SizedBox()
                                ],
                              ),
                              CustomText(
                                  color:
                                      rentxcontext.theme.customTheme.headline3,
                                  fontSize: width(14),
                                  text: bookings.car!.fullName),
                              SizedBox(
                                height: height(10),
                              ),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    "assets/img/calendar.svg",
                                  ),
                                  SizedBox(
                                    width: width(8),
                                  ),
                                  CustomText(
                                    color: rentxcontext
                                        .theme.customTheme.headline2,
                                    fontSize: width(14),
                                    text: DateUtil.displayRange(
                                        bookings.fromDate!, bookings.toDate!),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      thickness: 1.3,
                    ),
                    SizedBox(
                      height: height(10),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: PriceTag(
                            showPerDay: false,
                            price: bookings.totalPrice!,
                            fontSize: width(14),
                            color: rentxcontext.theme.customTheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          width: width(10),
                        ),
                        CustomButton(
                          btnWidth: width(82),
                          btnHeight: height(37),
                          background: rentxcontext.theme.customTheme.onRejected,
                          enabled: bookings.status! == BookingStatus.pending,
                          function: () {
                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              barrierColor: Colors.black.withOpacity(0.8),
                              builder: (context) => RejectionDialog(
                                bookings: bookings,
                              ),
                            );
                          },
                          radius: 8,
                          text: "reject",
                          fontSize: width(14),
                        ),
                        SizedBox(
                          width: width(8),
                        ),
                        CustomButton(
                          btnHeight: height(37),
                          btnWidth: width(98),
                          fontSize: width(14),
                          background: rentxcontext.theme.customTheme.primary,
                          enabled: bookings.status! == BookingStatus.pending,
                          function: () {
                            showDialog(
                              barrierColor: Colors.black.withOpacity(0.8),
                              context: context,
                              builder: (context) => ApproveDialog(
                                bookings: bookings,
                              ),
                            );
                          },
                          radius: 8,
                          text: "approve",
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}

class RejectionDialog extends StatelessWidget {
  const RejectionDialog({Key? key, required this.bookings}) : super(key: key);

  final CompanyBooking bookings;

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return RentXWidget(
      builder: (rentXContext) => BlocConsumer<BookingCubit, BookingStates>(
          listener: (context, state) {},
          builder: (context, state) {
            BookingCubit cubit = BookingCubit.get(context);
            return Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: width(10),
                      vertical: height(24),
                    ),
                    margin: EdgeInsets.symmetric(
                      horizontal: width(23),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(width(16)),
                      color: rentXContext.theme.customTheme.onPrimary,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: CustomText(
                              color: rentXContext.theme.customTheme.headdline,
                              fontSize: width(16),
                              text: "rejectConfirmation",
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            height: height(24),
                          ),
                          CustomText(
                            color: rentXContext.theme.customTheme.headdline,
                            fontSize: width(14),
                            text: "reason",
                          ),
                          CustomDropdownSearch<String>(
                              showSearchBox: false,
                              entries: cubit.rejectionList,
                              onChange: (reason) =>
                                  cubit.chooseRejection(reason),
                              enabled: true,
                              selectedValue: cubit.rejectionModel,
                              validator: Validators.required,
                              label: 'selectReason'),
                          SizedBox(
                            height: height(24),
                          ),
                          PropertiesWidget(
                            name: "description",
                            isDiscription: true,
                            onChange: (value) {
                              cubit.onChangeDescription(value);
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: CustomText(
                                  color:
                                      rentXContext.theme.customTheme.headline2,
                                  fontSize: width(16),
                                  text: "cancel",
                                ),
                              ),
                              Container(
                                height: height(40),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: rentXContext.theme.customTheme.primary,
                                ),
                                child: CustomButton(
                                  btnHeight: height(40),
                                  btnWidth: width(99),
                                  showLoader:
                                      state is BookingConfirmLoadingState,
                                  fontSize: width(16),
                                  function: () {
                                    if (_formKey.currentState!.validate()) {
                                      cubit.rejectConfirmation(bookings.id!);
                                      rentXContext.pop();
                                    }
                                  },
                                  text: "confirm",
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}

class ApproveDialog extends StatelessWidget {
  const ApproveDialog({Key? key, required this.bookings}) : super(key: key);

  final CompanyBooking bookings;

  @override
  Widget build(BuildContext context) {
    return RentXWidget(
      builder: (rentXContext) => BlocConsumer<BookingCubit, BookingStates>(
          listener: (context, state) {},
          builder: (context, state) {
            BookingCubit cubit = BookingCubit.get(context);
            return Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: width(16),
                      vertical: height(10),
                    ),
                    margin: EdgeInsets.symmetric(
                      horizontal: width(16),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: rentXContext.theme.customTheme.onPrimary,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/img/done.svg",
                        ),
                        SizedBox(
                          height: height(16),
                        ),
                        CustomText(
                            color: rentXContext.theme.customTheme.headdline,
                            align: TextAlign.center,
                            maxlines: 2,
                            fontSize: width(14),
                            text: "approveBooking.question"),
                        SizedBox(
                          height: height(16),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: CustomText(
                                color: rentXContext.theme.customTheme.headline2,
                                fontSize: width(16),
                                text: "cancel",
                              ),
                            ),
                            SizedBox(
                              width: width(16),
                            ),
                            Container(
                              height: height(40),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: rentXContext.theme.customTheme.primary,
                              ),
                              child: CustomButton(
                                btnHeight: height(40),
                                btnWidth: width(70),
                                showLoader: state is BookingConfirmLoadingState,
                                fontSize: width(16),
                                function: () {
                                  cubit.approveConfirmation(bookings.id!);
                                  rentXContext.pop();
                                },
                                text: "Yes",
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
