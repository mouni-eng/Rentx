import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rentx/size_config.dart';
import 'package:rentx/ui/base_widget.dart';
import 'package:rentx/view_models/client_booking_list_cubit/cubit.dart';
import 'package:rentx/view_models/home_cubit/cubit.dart';
import 'package:rentx/view_models/home_cubit/states.dart';
import 'package:rentx/view_models/profile_cubit/cubit.dart';
import 'package:rentx/view_models/search_cubit/cubit.dart';

class LayoutScreen extends StatelessWidget {
  const LayoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return RentXWidget(
      builder: (rentxcontext) => BlocConsumer<HomeCubit, HomeStates>(
        listener: (context, state) {
          if (state is ChooseBottomNavState) {
            if (state.index == 1) {
              SearchCubit.get(context).getMapRentals();
              state.completeNavigation(true);
            } else if (state.index == 2) {
              rentxcontext
                  .requireAuth(
                      () => ClientBookingsCubit.get(context).getBookings())
                  .then((value) => state.completeNavigation(value));
            } else if (state.index == 3) {
              rentxcontext
                  .requireAuth(() => ProfileCubit.get(context).getProfileData())
                  .then((value) => state.completeNavigation(value));
            } else {
              state.completeNavigation(true);
            }
          }
        },
        builder: (context, state) {
          HomeCubit cubit = HomeCubit.get(context);
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: SafeArea(
              child: cubit.screens[cubit.bottomNavIndex],
            ),
            bottomNavigationBar: SizedBox(
              width: double.infinity,
              height: height(70),
              child: BottomNavigationBar(
                selectedLabelStyle: TextStyle(
                  color: rentxcontext.theme.customTheme.primary,
                  fontSize: width(12),
                ),
                unselectedLabelStyle: TextStyle(
                  color: rentxcontext.theme.customTheme.headline2,
                  fontSize: width(12),
                ),
                items: [
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      "assets/img/home.svg",
                      width: width(20.1),
                      height: height(20.1),
                      color: rentxcontext.theme.customTheme.headdline,
                    ),
                    activeIcon: SvgPicture.asset(
                      "assets/img/home.svg",
                      width: width(20.1),
                      height: height(20.1),
                      color: rentxcontext.theme.customTheme.primary,
                    ),
                    label: rentxcontext.translate("Explore"),
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      "assets/img/search-nav.svg",
                      width: width(20.1),
                      height: height(20.1),
                    ),
                    activeIcon: SvgPicture.asset(
                      "assets/img/search-nav.svg",
                      width: width(20.1),
                      height: height(20.1),
                      color: rentxcontext.theme.customTheme.primary,
                    ),
                    label: rentxcontext.translate("Search"),
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      "assets/img/cars.svg",
                      width: width(20.1),
                      height: height(20.1),
                    ),
                    activeIcon: SvgPicture.asset(
                      "assets/img/cars.svg",
                      width: width(20.1),
                      height: height(20.1),
                      color: rentxcontext.theme.customTheme.primary,
                    ),
                    label: rentxcontext.translate("Cars"),
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      "assets/img/people-nav.svg",
                      width: width(20.1),
                      height: height(20.1),
                    ),
                    activeIcon: SvgPicture.asset(
                      "assets/img/people-nav.svg",
                      width: width(20.1),
                      height: height(20.1),
                      color: rentxcontext.theme.customTheme.primary,
                    ),
                    label: rentxcontext.translate("Profile"),
                  ),
                ],
                currentIndex: cubit.bottomNavIndex,
                onTap: (value) {
                  cubit.chooseBottomNavIndex(value);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
