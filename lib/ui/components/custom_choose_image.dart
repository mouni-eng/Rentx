import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rentx/size_config.dart';
import 'package:rentx/ui/base_widget.dart';

import 'dotted_border/dotted_border.dart';

class ChooseImageWidget extends StatelessWidget {
  const ChooseImageWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RentXWidget(
      builder: (context) => Padding(
        padding:
            EdgeInsets.symmetric(horizontal: width(3), vertical: height(3)),
        child: DottedBorder(
          radius: const Radius.circular(8),
          color: context.theme.customTheme.primary,
          child: Container(
            width: width(98),
            margin: EdgeInsets.symmetric(
                horizontal: width(3), vertical: height(3)),
            height: height(93),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: SvgPicture.asset("assets/img/camera.svg"),
            ),
          ),
        ),
      ),
    );
  }
}
