import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rentx/infrastructure/utils.dart';
import 'package:rentx/models/user.dart';
import 'package:rentx/size_config.dart';
import 'package:rentx/ui/base_widget.dart';
import 'package:rentx/ui/components/car_fleet_widget.dart';
import 'package:rentx/ui/components/custom_text.dart';
import 'package:rentx/ui/components/header_widget.dart';
import 'package:rentx/ui/screens/car_fleet_screen.dart';
import 'package:rentx/ui/screens/car_listing_screens/car_listing_screen.dart';
import 'package:rentx/ui/screens/client_car_fleet_list.dart';
import 'package:rentx/ui/screens/layout_screens/profile_screen.dart';
import 'package:rentx/ui/screens/manger_screens/manager_layout_screen.dart';
import 'package:rentx/view_models/car_fleet_cubit/cubit.dart';
import 'package:rentx/view_models/company_cubit/cubit.dart';
import 'package:rentx/view_models/company_cubit/states.dart';
import 'package:rentx/view_models/manager_cubit/cubit.dart';
import 'package:rentx/view_models/rental_details_cubit/cubit.dart';

class CompanyDetailsScreen extends StatelessWidget {
  const CompanyDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RentXWidget(
      builder: (rentxcontext) => BlocConsumer<CompanyCubit, CompanyStates>(
        builder: (context, state) {
          CompanyCubit cubit = CompanyCubit.get(context);
          return Scaffold(
              body: SafeArea(
                  child: ConditionalBuilder(
            condition: state is! GetCompanyInfoLoadingState,
            fallback: (context) => const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
            builder: (context) => SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: width(24),
                  vertical: height(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        BackButtonWidget(
                          onTap: () {
                            rentxcontext.authenticatedAction(
                                (context, isLoggedIn, userRole) {
                              if (isLoggedIn && userRole == UserRole.manager) {
                                ManagerCubit.get(context).changeBottomNav(0);
                              } else {
                                rentxcontext.pop();
                              }
                            });
                          },
                          rentxcontext: rentxcontext,
                        ),
                        SizedBox(
                          width: width(16),
                        ),
                        CustomText(
                          color: rentxcontext.theme.customTheme.headdline,
                          fontSize: width(22),
                          text: "Company Info",
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height(30),
                    ),
                    SizedBox(
                      height: height(190.0),
                      child: Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          Align(
                            child: cubit.companyInfoModel!.bannerUrl == null
                                ? Container(
                                    height: height(146.5),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: rentxcontext
                                          .theme.customTheme.headline4,
                                    ),
                                  )
                                : Container(
                                    height: height(146.5),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: rentxcontext
                                          .theme.customTheme.headline4,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image(
                                        image: NetworkImage(
                                            cubit.companyInfoModel!.bannerUrl!),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                            alignment: AlignmentDirectional.topCenter,
                          ),
                          CircleAvatar(
                            radius: width(65),
                            backgroundColor:
                                rentxcontext.theme.customTheme.onPrimary,
                            child: cubit.companyInfoModel!.logoUrl == null
                                ? CircleAvatar(
                                    radius: width(62),
                                    backgroundColor: rentxcontext
                                        .theme.customTheme.headline4,
                                    child: Center(
                                      child: CustomText(
                                          color: rentxcontext
                                              .theme.customTheme.headline3,
                                          fontWeight: FontWeight.w800,
                                          fontSize: width(20),
                                          text: "LOGO"),
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: width(62),
                                    backgroundColor: rentxcontext
                                        .theme.customTheme.headline4,
                                    backgroundImage: NetworkImage(
                                        cubit.companyInfoModel!.logoUrl!),
                                  ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height(8),
                    ),
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomText(
                            color: rentxcontext.theme.customTheme.headdline,
                            fontSize: width(18),
                            text: cubit.companyInfoModel!.name!,
                            fontWeight: FontWeight.w600,
                          ),
                          CustomText(
                            color: rentxcontext.theme.customTheme.headline2,
                            fontSize: width(16),
                            text: cubit.companyInfoModel!.email!,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
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
                      fontSize: width(16),
                      text: "Address",
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(
                      height: height(8),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          "assets/img/location.svg",
                          color: rentxcontext.theme.customTheme.primary,
                        ),
                        SizedBox(
                          width: width(7),
                        ),
                        if (cubit.companyInfoModel!.address != null)
                          Expanded(
                            child: CustomText(
                              color: rentxcontext.theme.customTheme.primary,
                              fontSize: width(12),
                              maxlines: 2,
                              text: cubit.companyInfoModel!.address!
                                  .fullAddress(),
                            ),
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
                    CustomText(
                      color: rentxcontext.theme.customTheme.headdline,
                      fontSize: width(16),
                      text: "Phone Number",
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(
                      height: height(8),
                    ),
                    CustomText(
                      color: rentxcontext.theme.customTheme.headline2,
                      fontSize: width(16),
                      text: cubit.companyInfoModel!.phone!,
                      fontWeight: FontWeight.w400,
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
                      fontSize: width(16),
                      text: "About Us",
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(
                      height: height(8),
                    ),
                    CustomText(
                      color: rentxcontext.theme.customTheme.headline2,
                      fontSize: width(16),
                      text: cubit.companyInfoModel!.description!,
                      fontWeight: FontWeight.w400,
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
                    HeaderWidget(
                      title: "carFleet",
                      onTap: () {
                        rentxcontext.authenticatedRoute(
                            (context, isLoggedIn, userRole) {
                          CarFleetCubit.get(context)
                              .setCarFleet(cubit.companyRentals);
                          if (isLoggedIn && userRole! == UserRole.manager) {
                            ManagerCubit.get(context).changeBottomNav(1);
                            return const ManagerLayoutScreen();
                          }
                          return ClientCarFleetList(
                              company: cubit.companyInfoModel!,
                              rentals: cubit.companyRentals);
                        });
                      },
                    ),
                    SizedBox(
                      height: height(10),
                    ),
                    if (cubit.companyRentals.isNotEmpty)
                      CarFleetList(
                          onItemTapFn: (rental) {
                            rentxcontext.authenticatedRoute(
                                (context, isLoggedIn, userRole) {
                              if (isLoggedIn && userRole == UserRole.manager) {
                                CarFleetCubit.get(context)
                                    .getCarFleetDetails(rental.id!);
                                return const CarFleetScreen();
                              }
                              RentalDetailsCubit.get(context)
                                  .getRentalDetails(rental.id!);
                              return const RentalCarListingScreen();
                            });
                          },
                          rentals: cubit.companyRentals.sublist(
                              0,
                              NumberUtil.getLower(
                                  2, cubit.companyRentals.length)))
                  ],
                ),
              ),
            ),
          )));
        },
        listener: (context, state) {},
      ),
    );
  }
}
