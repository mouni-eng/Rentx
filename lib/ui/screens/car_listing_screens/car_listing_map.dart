import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rentx/constants.dart';
import 'package:rentx/models/company.dart';
import 'package:rentx/models/location.dart';
import 'package:rentx/size_config.dart';
import 'package:rentx/ui/base_widget.dart';
import 'package:rentx/ui/components/custom_text.dart';
import 'package:rentx/ui/widgets/map/rentx_map_card.dart';

class CarListingMap extends StatelessWidget {
  final Company company;
  final RentXMapController mapController;
  final String? label;
  final EdgeInsetsGeometry? padding;

  const CarListingMap(
      {Key? key,
      required this.company,
      required this.mapController,
      this.label,
      this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RentXWidget(
        builder: (rentxcontext) => Container(
              width: double.infinity,
              padding: padding ??
                  EdgeInsets.symmetric(
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
                  if (label != null)
                    CustomText(
                      color: rentxcontext.theme.customTheme.headdline,
                      fontSize: width(14),
                      text: label!,
                    ),
                  if (label != null)
                    SizedBox(
                      height: height(6),
                    ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: RentXMapCard(
                        disableNavigation: true,
                        width: double.infinity,
                        height: height(123),
                        controller: mapController,
                        location: RentXLocation(
                          street: company.address!.fullAddress(),
                          city: company.address!.city!.name!,
                          state: company.address!.city!.country!,
                          zip: company.address!.city!.countryCode!,
                          latitude: company.address!.latitude!,
                          longitude: company.address!.longitude!,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height(16),
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        "assets/img/location.svg",
                        color: rentxcontext.theme.customTheme.primary,
                      ),
                      SizedBox(
                        width: width(7),
                      ),
                      Expanded(
                        child: CustomText(
                            color: rentxcontext.theme.customTheme.primary,
                            fontSize: width(12),
                            maxlines: 1,
                            text: company.address!.fullAddress()),
                      ),
                    ],
                  ),
                ],
              ),
            ));
  }
}
