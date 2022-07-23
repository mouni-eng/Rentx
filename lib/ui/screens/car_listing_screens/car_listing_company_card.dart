import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rentx/constants.dart';
import 'package:rentx/models/company.dart';
import 'package:rentx/size_config.dart';
import 'package:rentx/ui/base_widget.dart';
import 'package:rentx/ui/components/custom_text.dart';
import 'package:rentx/ui/components/rentx_cached_image.dart';

class CompanyCard extends StatelessWidget {
  const CompanyCard({Key? key, required this.company}) : super(key: key);

  final Company company;

  @override
  Widget build(BuildContext context) {
    return RentXWidget(
      builder: (rentxcontext) => Container(
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
        child: Row(
          children: [
            Container(
              width: width(76),
              height: height(76),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: rentxcontext.theme.customTheme.outerBorder,
                ),
              ),
              child: RentXCachedImage(
                  boxFit: BoxFit.fitWidth,
                  url: company.logoUrl ??
                      "https://th.bing.com/th/id/OIP.9VGo-82x4XWV3oR2XjsN9gHaCj?pid=ImgDet&w=1026&h=354&rs=1"),
            ),
            SizedBox(
              width: width(12),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomText(
                      color: rentxcontext.theme.customTheme.headdline,
                      fontSize: width(14),
                      text: company.name!),
                  CustomText(
                      color: rentxcontext.theme.customTheme.headline3,
                      fontSize: width(14),
                      text: company.address!.fullAddress()),
                ],
              ),
            ),
            SvgPicture.asset(
              "assets/img/arrow-left.svg",
              color: rentxcontext.theme.customTheme.secondary,
            ),
          ],
        ),
      ),
    );
  }
}
