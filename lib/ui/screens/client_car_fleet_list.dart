import 'package:flutter/material.dart';
import 'package:rentx/models/company_info_model.dart';
import 'package:rentx/models/rental_model.dart';
import 'package:rentx/size_config.dart';
import 'package:rentx/ui/base_widget.dart';
import 'package:rentx/ui/components/car_fleet_widget.dart';
import 'package:rentx/ui/components/company_info_badge.dart';
import 'package:rentx/ui/components/custom_text.dart';
import 'package:rentx/ui/screens/layout_screens/layout_screen.dart';
import 'package:rentx/view_models/home_cubit/cubit.dart';
import 'package:rentx/view_models/rental_details_cubit/cubit.dart';

import 'car_listing_screens/car_listing_screen.dart';
import 'layout_screens/profile_screen.dart';

class ClientCarFleetList extends StatelessWidget {
  const ClientCarFleetList(
      {Key? key, required this.company, required this.rentals})
      : super(key: key);

  final CompanyInfoModel company;
  final List<RentalResult> rentals;

  @override
  Widget build(BuildContext context) {
    return RentXWidget(
        builder: (rentXContext) => Scaffold(
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
                                rentXContext.pop();
                              },
                              rentxcontext: rentXContext,
                            ),
                            SizedBox(
                              width: width(16),
                            ),
                            CustomText(
                              color: rentXContext.theme.customTheme.headdline,
                              fontSize: width(22),
                              text: "companyFleet",
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height(24),
                        ),
                        CompanyInfoBadge(
                            companyName: company.name!,
                            logoUrl: company.logoUrl,
                            fullAddress: company.address!.fullAddress()),
                        SizedBox(
                          height: height(10),
                        ),
                        const Divider(),
                        SizedBox(
                          height: height(5),
                        ),
                        CarFleetList(
                          rentals: rentals,
                          onItemTapFn: (rental) {
                            RentalDetailsCubit.get(context)
                                .getRentalDetails(rental.id!);
                            rentXContext
                                .route((p0) => const RentalCarListingScreen());
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }
}
