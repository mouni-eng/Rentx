import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rentx/models/location.dart';
import 'package:rentx/size_config.dart';
import 'package:rentx/ui/components/custom_text.dart';
import 'package:rentx/ui/components/rentx_search_input.dart';

class RentXLocationSearchbar extends StatelessWidget {
  final Future<List<RentXLocation>> Function(String) locationProvider;
  final Function(RentXLocation) onLocationPick;
    final void Function() onDismiss;
  final void Function() onTap;
  final bool isVisible;

  const RentXLocationSearchbar(
      {Key? key, required this.locationProvider, required this.onLocationPick, required this.onDismiss, required this.onTap, required this.isVisible})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MapSearchBar<RentXLocation>(
      isVissible: isVisible,
      onDismiss: onDismiss,
      onTap: onTap,
      leadingIcon: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width(17),
          vertical: height(17),
        ),
        child: SvgPicture.asset(
          "assets/img/search.svg",
        ),
      ),
      onChange: locationProvider,
      placeholder: 'Search here...',
      itemBuilder: (item) => Container(
        height: height(30),
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        child: Row(
          children: [
            const Icon(Icons.location_on),
            Expanded(
                child: CustomText(
              text: item.fullAddress(),
              fontSize: width(12),
            ))
          ],
        ),
      ),
      onItemClick: onLocationPick,
      valueProvider: (item) => item.fullAddress(),
    );
  }
}
