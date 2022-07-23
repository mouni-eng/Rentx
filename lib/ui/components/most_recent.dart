import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rentx/models/car.dart';
import 'package:rentx/models/rental_model.dart';
import 'package:rentx/size_config.dart';
import 'package:rentx/ui/base_widget.dart';
import 'package:rentx/ui/components/custom_text.dart';
import 'package:rentx/ui/components/price_tag.dart';
import 'package:rentx/ui/screens/car_listing_screens/car_listing_screen.dart';
import 'package:rentx/view_models/home_cubit/cubit.dart';
import 'package:rentx/view_models/home_cubit/states.dart';
import 'package:rentx/view_models/rental_details_cubit/cubit.dart';

class MostRecentWidget extends StatefulWidget {
  const MostRecentWidget({
    Key? key,
    required this.mostRecentModel,
  }) : super(key: key);

  final RentalResult mostRecentModel;

  @override
  State<MostRecentWidget> createState() => _MostRecentWidgetState();
}

class _MostRecentWidgetState extends State<MostRecentWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RentXWidget(
      builder: (rentxcontext) => BlocConsumer<HomeCubit, HomeStates>(
        listener: (context, state) {},
        builder: (context, state) {
          HomeCubit cubit = HomeCubit.get(context);
          return GestureDetector(
            onTap: () {
              RentalDetailsCubit.get(context)
                  .getRentalDetails(widget.mostRecentModel.id!);
              rentxcontext.route((p0) => const RentalCarListingScreen());
            },
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: height(196),
                  margin: EdgeInsets.symmetric(
                    horizontal: width(5),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.black.withOpacity(0.9)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: CachedNetworkImage(
                            imageUrl:
                                widget.mostRecentModel.rentalImages![0].url!,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned.fill(
                          child: Container(
                            height: height(91),
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Color(0xFF000000),
                                  ],
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0.0,
                  right: 0.0,
                  left: 0.0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: width(12),
                      vertical: height(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              color: rentxcontext.theme.customTheme.onPrimary,
                              fontSize: width(14),
                              fontWeight: FontWeight.w700,
                              text: rentxcontext.translate(
                                  widget.mostRecentModel.car!.model!),
                            ),
                            SizedBox(
                              height: height(1.5),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SvgPicture.asset("assets/img/people.svg"),
                                SizedBox(
                                  width: width(6),
                                ),
                                CustomText(
                                  color:
                                      rentxcontext.theme.customTheme.onPrimary,
                                  fontSize: width(12),
                                  text:
                                      "${widget.mostRecentModel.getProperty(CarPropertyType.seats)?.value ?? '-'} ${rentxcontext.translate(CarPropertyType.seats.name)}",
                                ),
                              ],
                            ),
                          ],
                        ),
                        if (widget.mostRecentModel.price != null)
                          PriceTag(
                            color: rentxcontext.theme.customTheme.onPrimary,
                            fontSize: width(14),
                            fontWeight: FontWeight.w700,
                            price: widget.mostRecentModel.price!,
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
