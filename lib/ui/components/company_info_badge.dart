import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rentx/constants.dart';
import 'package:rentx/size_config.dart';
import 'package:rentx/ui/base_widget.dart';

import 'custom_text.dart';
import 'rentx_rect_image.dart';

class CompanyInfoBadge extends StatelessWidget {
  const CompanyInfoBadge(
      {Key? key,
      required this.companyName,
      this.logoUrl,
      required this.fullAddress})
      : super(key: key);

  final String companyName;
  final String? logoUrl;
  final String fullAddress;

  get _companyAvatarLetters {
    List<String> parts = companyName.split(' ');
    return parts.first[0] + parts.last[0];
  }

  @override
  Widget build(BuildContext context) {
    return RentXWidget(
        builder: (rentXContext) => Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: width(16),
                vertical: height(16),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: rentXContext.theme.customTheme.onPrimary,
                border: Border.all(
                  color: rentXContext.theme.customTheme.primary,
                ),
                boxShadow: [boxShadow],
              ),
              child: Row(
                children: [
                  RentXRectImage(
                      imageSrc: logoUrl, avatarLetters: _companyAvatarLetters),
                  SizedBox(
                    width: width(16),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          color: rentXContext.theme.customTheme.headdline,
                          fontSize: width(18),
                          text: companyName,
                          fontWeight: FontWeight.w600,
                        ),
                        SizedBox(
                          height: height(6),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              "assets/img/location.svg",
                              color: rentXContext.theme.customTheme.primary,
                            ),
                            SizedBox(
                              width: width(7),
                            ),
                            Expanded(
                              child: CustomText(
                                  color: rentXContext.theme.customTheme.primary,
                                  fontSize: width(12),
                                  maxlines: 2,
                                  text: fullAddress),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ));
  }
}
