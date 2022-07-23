import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:provider/provider.dart';
import 'package:rentx/models/user.dart';
import 'package:rentx/services/auth_service.dart';
import 'package:rentx/theme/app_notifier.dart';
import 'package:rentx/theme/app_theme.dart';
import 'package:rentx/ui/screens/layout_screens/layout_screen.dart';
import 'package:rentx/ui/screens/manger_screens/manager_layout_screen.dart';
import 'package:rentx/view_models/auth_cubit/cubit.dart';
import 'package:rentx/view_models/booking_cubit/cubit.dart';
import 'package:rentx/view_models/car_fleet_cubit/cubit.dart';
import 'package:rentx/view_models/car_listing_cubit/cubit.dart';
import 'package:rentx/view_models/client_booking_details_cubit/cubit.dart';
import 'package:rentx/view_models/company_auth_cubit/cubit.dart';
import 'package:rentx/view_models/company_cubit/cubit.dart';
import 'package:rentx/view_models/create_booking_cubit/cubit.dart';
import 'package:rentx/view_models/filter_cubit/cubit.dart';
import 'package:rentx/view_models/home_cubit/cubit.dart';
import 'package:rentx/view_models/login_cubit/cubit.dart';
import 'package:rentx/view_models/manager_cubit/cubit.dart';
import 'package:rentx/view_models/password_reset_cubit/cubit.dart';
import 'package:rentx/view_models/profile_cubit/cubit.dart';
import 'package:rentx/view_models/rental_details_cubit/cubit.dart';
import 'package:rentx/view_models/search_cubit/cubit.dart';

import 'view_models/client_booking_list_cubit/cubit.dart';

void main() {
  //You will need to initialize AppThemeNotifier class for theme changes.
  final AuthService _authService = AuthService();

  WidgetsFlutterBinding.ensureInitialized();

  _authService.loggedUserDetails(forceRefresh: true).then((value) {
    runRentXApp(value);
  }).catchError((e) {
    runRentXApp(null);
  });
}

void runRentXApp(UserDetails? userDetails) {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(ChangeNotifierProvider<AppNotifier>(
      create: (context) => AppNotifier(),
      child: RentXApp(
        userDetails: userDetails,
      ),
    ));
  });
}

class RentXApp extends StatelessWidget {
  const RentXApp({Key? key, this.userDetails}) : super(key: key);

  final UserDetails? userDetails;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppNotifier>(
        builder: (BuildContext context, AppNotifier value, Widget? child) {
      return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => CarListingCubit(),
          ),
          BlocProvider(create: (_) => HomeCubit()),
          BlocProvider(create: (_) => AuthCubit()),
          BlocProvider(create: (_) => CompanyAuthCubit()),
          BlocProvider(create: (_) => LogInCubit()),
          BlocProvider(create: (_) => CompanyCubit()),
          BlocProvider(create: (_) => RentalDetailsCubit()),
          BlocProvider(create: (_) => BookingCubit()),
          BlocProvider(create: (_) => SearchCubit()..init()),
          BlocProvider(create: (_) => ProfileCubit()),
          BlocProvider(create: (_) => CreateBookingCubit()),
          BlocProvider(create: (_) => ManagerCubit()),
          BlocProvider(create: (_) => CarFleetCubit()),
          BlocProvider(create: (_) => FilterCubit()),
          BlocProvider(create: (_) => ClientBookingsCubit()),
          BlocProvider(create: (_) => ClientBookingDetailsCubit()),
          BlocProvider(create: (_) => PasswordResetCubit()),
        ],
        child: Portal(
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.theme,
            home: ConditionalBuilder(
              condition:
                  userDetails == null || userDetails!.role == UserRole.client,
              builder: (context) {
                HomeCubit.get(context).getHomeData();
                return const LayoutScreen();
              },
              fallback: (context) {
                BookingCubit.get(context).getBookings();
                return const ManagerLayoutScreen();
              },
            ),
          ),
        ),
      );
    });
  }
}
