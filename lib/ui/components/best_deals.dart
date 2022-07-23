import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rentx/size_config.dart';
import 'package:rentx/ui/base_widget.dart';
import 'package:rentx/ui/components/custom_text.dart';
import 'package:rentx/ui/components/price_tag.dart';
import 'package:rentx/ui/screens/car_listing_screens/car_listing_screen.dart';
import 'package:rentx/view_models/home_cubit/cubit.dart';
import 'package:rentx/view_models/home_cubit/states.dart';
import 'package:rentx/view_models/rental_details_cubit/cubit.dart';

import '../../models/rental_model.dart';

class BestDealsWidget extends StatefulWidget {
  const BestDealsWidget({
    Key? key,
    required this.model,
  }) : super(key: key);

  final RentalResult model;

  @override
  State<BestDealsWidget> createState() => _BestDealsWidgetState();
}

class _BestDealsWidgetState extends State<BestDealsWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RentXWidget(
      builder: (rentxcontext) => BlocConsumer<HomeCubit, HomeStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return GestureDetector(
            onTap: () {
              RentalDetailsCubit.get(context)
                  .getRentalDetails(widget.model.id!);
              rentxcontext.route((p0) => const RentalCarListingScreen());
            },
            child: Container(
              height: height(115),
              padding: EdgeInsets.symmetric(
                horizontal: width(16),
                vertical: height(8),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: rentxcontext.theme.customTheme.onPrimary,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF000000)
                        .withOpacity(0.06), //color of shadow
                    //spread radius
                    blurRadius: width(30), // blur radius
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          color: rentxcontext.theme.customTheme.headdline,
                          fontSize: width(16),
                          fontWeight: FontWeight.w600,
                          text: rentxcontext.translate(widget.model.car!.make!),
                        ),
                        SizedBox(
                          height: height(2),
                        ),
                        CustomText(
                            color: rentxcontext.theme.customTheme.headline2,
                            fontSize: width(10),
                            text: rentxcontext
                                .translate(widget.model.car!.model!)),
                        SizedBox(
                          height: height(5),
                        ),
                        Row(
                          children: [
                            SvgPicture.asset("assets/img/star.svg"),
                            CustomText(
                              color: const Color(0xFF828282),
                              fontSize: width(10),
                              text: rentxcontext
                                  .translate(widget.model.rating!.toString()),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height(5),
                        ),
                        if (widget.model.price != null)
                          PriceTag(
                              color: rentxcontext.theme.customTheme.primary,
                              fontSize: width(10),
                              fontWeight: FontWeight.w600,
                              price: widget.model.price!),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                        width: width(174),
                        height: height(91),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.black.withOpacity(0.9)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: widget.model.rentalImages![0].url!,
                            fit: BoxFit.cover,
                          ),
                        )),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
