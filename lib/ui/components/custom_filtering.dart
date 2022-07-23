import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rentx/size_config.dart';
import 'package:rentx/ui/base_widget.dart';
import 'package:rentx/ui/components/custom_text.dart';
import 'package:rentx/ui/screens/home/filtring_screen.dart';
import 'package:rentx/view_models/filter_cubit/cubit.dart';

class CustomFilterWidget extends StatelessWidget {
  const CustomFilterWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RentXWidget(
      builder: (rentxcontext) => GestureDetector(
        onTap: () {
          FilterCubit.get(context).initialize();
          showModalBottomSheet(
              context: context,
              builder: (context) => const FilterScreenWidget());
        },
        child: Container(
          width: double.infinity,
          height: height(46),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color(0xFFE0E0E0),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: width(24),
                height: height(24),
                child: SvgPicture.asset("assets/img/filter.svg"),
              ),
              SizedBox(
                width: width(15),
              ),
              CustomText(
                color: rentxcontext.theme.customTheme.primary,
                fontSize: width(12),
                text: rentxcontext.translate("Sort & Filter"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
