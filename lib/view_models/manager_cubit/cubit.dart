import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentx/ui/screens/layout_screens/profile_screen.dart';
import 'package:rentx/ui/screens/manger_screens/booking_screen.dart';
import 'package:rentx/ui/screens/manger_screens/car_fleet_screen.dart';
import 'package:rentx/ui/screens/manger_screens/company_screen.dart';
import 'package:rentx/view_models/manager_cubit/states.dart';

class ManagerCubit extends Cubit<ManagerStates> {
  ManagerCubit() : super(ManagerStates());

  static ManagerCubit get(context) => BlocProvider.of(context);

  int managerIndex = 0;

  List<Widget> managerScreens = [
    const BookingManagerScreen(),
    const CarFleetListScreen(),
    const CompanyDetailsScreen(),
    const ProfileScreen(),
  ];

  changeBottomNav(int index) {
    managerIndex = index;
    emit(ChangeBottomNavState(index));
  }
}
