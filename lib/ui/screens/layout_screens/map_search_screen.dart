import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rentx/constants.dart';
import 'package:rentx/models/location.dart';
import 'package:rentx/models/rental_model.dart';
import 'package:rentx/services/alert_service.dart';
import 'package:rentx/size_config.dart';
import 'package:rentx/ui/base_widget.dart';
import 'package:rentx/ui/components/custom_button.dart';
import 'package:rentx/ui/components/custom_text.dart';
import 'package:rentx/ui/components/price_tag.dart';
import 'package:rentx/ui/components/rentx_search_input.dart';
import 'package:rentx/ui/screens/car_listing_screens/car_listing_screen.dart';
import 'package:rentx/ui/widgets/map/rentx_map_card.dart';
import 'package:rentx/view_models/home_cubit/cubit.dart';
import 'package:rentx/view_models/rental_details_cubit/cubit.dart';
import 'package:rentx/view_models/search_cubit/cubit.dart';
import 'package:rentx/view_models/search_cubit/states.dart';

class MapSearchScreen extends StatelessWidget {
  const MapSearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return RentXWidget(
      builder: (rentxcontext) => BlocConsumer<SearchCubit, SearchStates>(
        listener: (context, state) {
          if (state is GpsErrorState) {
            AlertService.showSnackbarAlert(
                state.error, rentxcontext, SnackbarType.error);
          }
        },
        builder: (context, state) {
          SearchCubit cubit = SearchCubit.get(context);
          return Stack(
            children: [
              RentXMapCard(
                width: double.infinity,
                location: cubit.location,
                controller: cubit.mapController,
                markers: cubit.mapRentals.map((e) {
                  return RentXMapMarker(
                      point: RentXLatLong(
                          e.company!.latitude!, e.company!.longitude!),
                      width: width(1000),
                      height: height(25),
                      builder: (context) => GestureDetector(
                            onTap: () {
                              cubit.getCurrentRental(e);
                            },
                            child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Container(
                                height: height(25),
                                padding: EdgeInsets.symmetric(
                                  horizontal: width(10),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color:
                                      rentxcontext.theme.customTheme.onPrimary,
                                  boxShadow: [
                                    boxShadow,
                                  ],
                                ),
                                child: Center(
                                  child: PriceTag(
                                    color: rentxcontext
                                        .theme.customTheme.headdline,
                                    fontSize: width(11),
                                    fontWeight: FontWeight.w600,
                                    price: e.price!,
                                    showPerDay: false,
                                  ),
                                ),
                              ),
                            ),
                          ));
                }).toList(),
              ),
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: width(16),
                    vertical: height(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SingleChildScrollView(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomButtonSearchScreen(
                              rentxcontext: rentxcontext,
                              onTap: () {
                                HomeCubit.get(context).chooseBottomNavIndex(0);
                              },
                              icon:
                                  const Icon(Icons.arrow_back_ios_new_rounded),
                            ),
                            SizedBox(
                              width: width(8),
                            ),
                            Expanded(
                              child: MapSearchTextField(
                                isVisible: cubit.isSearchVisible,
                                updateLocation: cubit.updateLocation,
                                searchLocation: cubit.searchLocation,
                                onDismiss: cubit.searchOnChange,
                                onTap: cubit.searchOnTap,
                              ),
                            ),
                            SizedBox(
                              width: width(8),
                            ),
                            CustomButtonSearchScreen(
                              rentxcontext: rentxcontext,
                              onTap: () {},
                              icon: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: width(10),
                                  vertical: height(10),
                                ),
                                child:
                                    SvgPicture.asset("assets/img/filter.svg"),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomButtonSearchScreen(
                            rentxcontext: rentxcontext,
                            icon: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: width(10),
                                vertical: height(10),
                              ),
                              child: SvgPicture.asset(
                                "assets/img/gps.svg",
                              ),
                            ),
                            onTap: () {
                              cubit.currentLocation();
                            },
                          ),
                          Column(
                            children: [
                              CustomButtonSearchScreen(
                                rentxcontext: rentxcontext,
                                icon: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: width(10),
                                    vertical: height(10),
                                  ),
                                  child:
                                      SvgPicture.asset("assets/img/minus.svg"),
                                ),
                                onTap: () =>
                                    cubit.mapController.zoomOut?.call(),
                              ),
                              SizedBox(
                                height: height(8),
                              ),
                              CustomButtonSearchScreen(
                                rentxcontext: rentxcontext,
                                icon: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: width(10),
                                    vertical: height(10),
                                  ),
                                  child: SvgPicture.asset("assets/img/add.svg"),
                                ),
                                onTap: () => cubit.mapController.zoomIn?.call(),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height(14),
                      ),
                      if (cubit.mapRentals.isNotEmpty)
                        CustomMapCarWidget(
                          rentxcontext: rentxcontext,
                          rentalResult: cubit.model ?? cubit.mapRentals[0],
                        ),
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

class CustomMapCarWidget extends StatelessWidget {
  const CustomMapCarWidget({
    Key? key,
    required this.rentxcontext,
    required this.rentalResult,
  }) : super(key: key);

  final RentXContext rentxcontext;

  final RentalResult rentalResult;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        RentalDetailsCubit.get(context).getRentalDetails(rentalResult.id!);
        rentxcontext.route((p0) => const RentalCarListingScreen());
      },
      child: Container(
        height: height(142),
        padding: EdgeInsets.symmetric(
          horizontal: width(16),
          vertical: height(8),
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    color: rentxcontext.theme.customTheme.headdline,
                    fontSize: width(16),
                    fontWeight: FontWeight.w600,
                    text: rentxcontext.translate(rentalResult.car!.make ?? ""),
                  ),
                  SizedBox(
                    height: height(2),
                  ),
                  CustomText(
                      color: rentxcontext.theme.customTheme.headline2,
                      fontSize: width(10),
                      text: rentxcontext
                          .translate(rentalResult.car!.model ?? "")),
                  SizedBox(
                    height: height(5),
                  ),
                  PriceTag(
                    color: rentxcontext.theme.customTheme.primary,
                    fontSize: width(10),
                    fontWeight: FontWeight.w600,
                    price: rentalResult.price!,
                  ),
                  SizedBox(
                    height: height(10),
                  ),
                  CustomButton(
                    btnWidth: width(114),
                    btnHeight: height(36),
                    fontSize: width(12),
                    function: () {
                      RentalDetailsCubit.get(context)
                          .getRentalDetails(rentalResult.id!);
                      rentxcontext
                          .route((context) => const RentalCarListingScreen());
                    },
                    text: "Book Now",
                  ),
                ],
              ),
            ),
            Container(
                width: width(154),
                height: height(110),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.black.withOpacity(0.9)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CachedNetworkImage(
                    imageUrl: rentalResult.rentalImages![0].url ??
                        "https://th.bing.com/th/id/R.198adcdf1eb35cdee4f2172280d979b3?rik=6PS%2biiPHLV%2bSyw&pid=ImgRaw&r=0",
                    fit: BoxFit.cover,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class MapSearchTextField extends StatelessWidget {
  const MapSearchTextField({
    Key? key,
    required this.isVisible,
    required this.updateLocation,
    required this.searchLocation,
    required this.onDismiss,
    required this.onTap,
  }) : super(key: key);

  final Function(RentXLocation) updateLocation;
  final Function(String) searchLocation;
  final void Function() onDismiss;
  final void Function() onTap;
  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    return RentXWidget(
      builder: (rentxcontext) => MapSearchBar<RentXLocation>(
        isVissible: isVisible,
        onDismiss: onDismiss,
        onTap: onTap,
        leadingIcon: Padding(
          padding: EdgeInsets.symmetric(
            vertical: height(14),
          ),
          child: SvgPicture.asset(
            "assets/img/search.svg",
          ),
        ),
        suffixIcon: Padding(
          padding: EdgeInsets.symmetric(
            vertical: height(14),
          ),
          child: SvgPicture.asset("assets/img/close1.svg"),
        ),
        onChange: (address) => searchLocation(address),
        placeholder: 'Search here...',
        itemBuilder: (item) => SizedBox(
          height: height(46),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: width(14),
                  vertical: height(14),
                ),
                child: item.locationType != RentXLocationType.city
                    ? SvgPicture.asset(
                        "assets/img/location.svg",
                        color: rentxcontext.theme.customTheme.headdline,
                      )
                    : SvgPicture.asset(
                        "assets/img/building.svg",
                        color: rentxcontext.theme.customTheme.headdline,
                      ),
              ),
              SizedBox(
                width: width(5),
              ),
              Expanded(
                child: CustomText(
                  color: rentxcontext.theme.customTheme.headline2,
                  fontSize: width(12),
                  text: item.fullAddress(),
                  maxlines: 1,
                ),
              ),
            ],
          ),
        ),
        onItemClick: (location) {
          updateLocation(location);
        },
        valueProvider: (item) => item.fullAddress(),
      ),
    );
  }
}

class CustomButtonSearchScreen extends StatelessWidget {
  const CustomButtonSearchScreen({
    Key? key,
    required this.rentxcontext,
    this.onTap,
    required this.icon,
  }) : super(key: key);

  final RentXContext rentxcontext;
  final Function()? onTap;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width(46),
        height: height(46),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: rentxcontext.theme.customTheme.onPrimary,
          boxShadow: [
            boxShadow,
          ],
        ),
        child: icon,
      ),
    );
  }
}
