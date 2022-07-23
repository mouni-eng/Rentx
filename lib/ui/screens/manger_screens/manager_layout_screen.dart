import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rentx/size_config.dart';
import 'package:rentx/ui/base_widget.dart';
import 'package:rentx/view_models/car_fleet_cubit/cubit.dart';
import 'package:rentx/view_models/company_cubit/cubit.dart';
import 'package:rentx/view_models/manager_cubit/cubit.dart';
import 'package:rentx/view_models/manager_cubit/states.dart';
import 'package:rentx/view_models/profile_cubit/cubit.dart';

class ManagerLayoutScreen extends StatelessWidget {
  const ManagerLayoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return RentXWidget(
        builder: (rentxcontext) => BlocConsumer<ManagerCubit, ManagerStates>(
                listener: (context, state) {
              if (state is ChangeBottomNavState) {
                if (state.index == 1) {
                  CarFleetCubit.get(context).getCarFleet();
                }
                if (state.index == 2) {
                  CompanyCubit.get(context).getLoggedUserCompany();
                  CarFleetCubit.get(context).getCarFleet();
                }
                if (state.index == 3) {
                  ProfileCubit.get(context).getProfileData();
                }
              }
            }, builder: (context, state) {
              ManagerCubit cubit = ManagerCubit.get(context);
              return Scaffold(
                  body: cubit.managerScreens[cubit.managerIndex],
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
                            "assets/img/booking.svg",
                            width: width(20.1),
                            height: height(20.1),
                            color: rentxcontext.theme.customTheme.headdline,
                          ),
                          activeIcon: SvgPicture.asset(
                            "assets/img/booking.svg",
                            width: width(20.1),
                            height: height(20.1),
                            color: rentxcontext.theme.customTheme.primary,
                          ),
                          label: rentxcontext.translate("Bookings"),
                        ),
                        BottomNavigationBarItem(
                          icon: SvgPicture.asset(
                            "assets/img/taxi.svg",
                            width: width(20.1),
                            height: height(20.1),
                          ),
                          activeIcon: SvgPicture.asset(
                            "assets/img/taxi.svg",
                            width: width(20.1),
                            height: height(20.1),
                            color: rentxcontext.theme.customTheme.primary,
                          ),
                          label: rentxcontext.translate("Cars"),
                        ),
                        BottomNavigationBarItem(
                          icon: SvgPicture.asset(
                            "assets/img/city.svg",
                            width: width(20.1),
                            height: height(20.1),
                          ),
                          activeIcon: SvgPicture.asset(
                            "assets/img/city.svg",
                            width: width(20.1),
                            height: height(20.1),
                            color: rentxcontext.theme.customTheme.primary,
                          ),
                          label: rentxcontext.translate("Company"),
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
                      currentIndex: cubit.managerIndex,
                      onTap: (value) {
                        cubit.changeBottomNav(value);
                      },
                    ),
                  ));
            }));
  }
}
