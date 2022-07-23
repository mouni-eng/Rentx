import 'package:flutter/material.dart';
import 'package:rentx/size_config.dart';
import 'package:rentx/ui/base_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SmoothCarouselIndicator extends StatelessWidget {
  final int count;
  final int initialPage;
  final int? currentPage;
  final Axis? axis;
  final dynamic indicatorEffect;

  const SmoothCarouselIndicator(
      {Key? key,
      required this.count,
      required this.currentPage,
      required this.initialPage,
      this.axis = Axis.horizontal,
      this.indicatorEffect})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RentXWidget(
      builder: (rentXContext) => AnimatedSmoothIndicator(
        count: count,
        axisDirection: axis!,
        effect: ExpandingDotsEffect(
            activeDotColor: rentXContext.theme.customTheme.primary,
            dotColor: rentXContext.theme.customTheme.inputFieldFillBold,
            dotHeight: width(4),
            expansionFactor: 8,
            radius: 30,
            dotWidth: width(5)),
        activeIndex: currentPage ?? initialPage,
      ),
    );
  }
}
