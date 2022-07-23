import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rentx/models/company_info_model.dart';
import 'package:rentx/size_config.dart';
import 'package:rentx/ui/base_widget.dart';
import 'package:rentx/ui/components/custom_text.dart';
import 'package:rentx/ui/screens/manger_screens/company_screen.dart';
import 'package:rentx/view_models/company_cubit/cubit.dart';

class FeaturedDealersWidget extends StatelessWidget {
  const FeaturedDealersWidget({
    Key? key,
    required this.model,
  }) : super(key: key);

  final CompanyInfoModel model;

  @override
  Widget build(BuildContext context) {
    return RentXWidget(
      builder: (rentxcontext) => GestureDetector(
        onTap: () {
          CompanyCubit.get(context).getCompanyInfo(model.id!);
          rentxcontext.route((p0) => const CompanyDetailsScreen());
        },
        child: Container(
          width: width(165),
          height: height(185),
          margin: EdgeInsets.symmetric(
            vertical: height(7),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: width(12),
            vertical: height(12),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color:
                    const Color(0xFF000000).withOpacity(0.05), //color of shadow
                //spread radius
                blurRadius: width(30), // blur radius
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                color: rentxcontext.theme.customTheme.secondary,
                fontSize: width(14),
                fontWeight: FontWeight.w600,
                text: rentxcontext.translate(model.name!),
              ),
              SizedBox(
                height: height(9),
              ),
              Container(
                width: width(141),
                height: height(100),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFFE0E0E0),
                  ),
                ),
                child: CachedNetworkImage(
                  imageUrl: model.logoUrl ??
                      "https://th.bing.com/th/id/R.d492f5b800cefd63fd3f5ea2e5599826?rik=cTKKkLxKxVV1OQ&riu=http%3a%2f%2fwww.sknvibes.com%2fautos_new%2fimg%2fxpress_auto_rental.jpg&ehk=KR4famB3UhHC%2b2zgQT4%2fWw3tuaMMlSklXtpQmrj0U64%3d&risl=&pid=ImgRaw&r=0",
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(
                height: height(12),
              ),
              Row(
                children: [
                  SvgPicture.asset("assets/img/location.svg"),
                  SizedBox(
                    width: width(7),
                  ),
                  CustomText(
                    color: rentxcontext.theme.customTheme.primary,
                    fontSize: width(12),
                    text:
                        rentxcontext.translate(model.address!.cityAndCountry()),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
