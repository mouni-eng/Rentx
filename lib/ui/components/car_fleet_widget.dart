import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rentx/infrastructure/utils.dart';
import 'package:rentx/models/rental_model.dart';
import 'package:rentx/size_config.dart';
import 'package:rentx/ui/base_widget.dart';

import 'badge_widget.dart';
import 'custom_text.dart';

class CarFleetList extends StatelessWidget {
  final List<RentalResult> rentals;
  final Function(RentalResult)? onItemTapFn;

  const CarFleetList({Key? key, required this.rentals, this.onItemTapFn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RentXWidget(
        builder: (rentXContext) => ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => CarFleetItemWidget(
                rentXContext: rentXContext,
                model: rentals[index],
                onTap: () => onItemTapFn?.call(rentals[index]),
              ),
              separatorBuilder: (context, index) => Column(
                children: [
                  SizedBox(
                    height: height(10),
                  ),
                  const Divider(
                    thickness: 1.3,
                  ),
                  SizedBox(
                    height: height(10),
                  ),
                ],
              ),
              itemCount: rentals.length,
            ));
  }
}

class CarFleetItemWidget extends StatelessWidget {
  const CarFleetItemWidget({
    Key? key,
    required this.rentXContext,
    required this.model,
    this.onTap,
  }) : super(key: key);

  final RentXContext rentXContext;
  final Function()? onTap;

  final RentalResult model;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: width(78),
            height: height(78),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.black.withOpacity(0.9)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: model.rentalImages![0].url ??
                    "https://th.bing.com/th/id/R.198adcdf1eb35cdee4f2172280d979b3?rik=6PS%2biiPHLV%2bSyw&pid=ImgRaw&r=0",
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
                  color: rentXContext.theme.customTheme.headdline,
                  fontSize: width(14),
                  text: model.car!.fullName(),
                  fontWeight: FontWeight.w600,
                ),
                CustomText(
                  color: rentXContext.theme.customTheme.headline3,
                  fontSize: width(13),
                  text: model.licensePlate ?? '-',
                ),
                SizedBox(
                  height: height(2),
                ),
                modelToWidget<RentalStatus>(
                        model.status,
                        (status) => CustomRectBadge(
                            text: status.name,
                            color: status.getTextColor(rentXContext),
                            bgColor: status.getBadgeColor(rentXContext))) ??
                    const SizedBox()
              ],
            ),
          )
        ],
      ),
    );
  }
}
