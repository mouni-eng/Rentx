import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentx/models/car_mdels.dart';
import 'package:rentx/models/company_info_model.dart';
import 'package:rentx/models/rental_filter_model.dart';
import 'package:rentx/models/rental_model.dart';
import 'package:rentx/services/car_service.dart';
import 'package:rentx/services/rental_service.dart';
import 'package:rentx/ui/screens/client_booking_list_screen.dart';
import 'package:rentx/ui/screens/layout_screens/home_screen.dart';
import 'package:rentx/ui/screens/layout_screens/map_search_screen.dart';
import 'package:rentx/ui/screens/layout_screens/profile_screen.dart';
import 'package:rentx/view_models/home_cubit/states.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeStates());

  static HomeCubit get(context) => BlocProvider.of(context);

  final RentalService _rentalService = RentalService();
  final CarService _carService = CarService();

  List<RentalResult> bestDealsRentals = [];
  List<RentalResult> firstBestDeals = [];
  List<RentalResult> mostRecentRentals = [];
  List<TopBrandsResult> topBrandsList = [];
  List<CompanyInfoModel> featuredDealersList = [];

  int bottomNavIndex = 0;

  List<Widget> screens = [
    const HomePageScreen(),
    const MapSearchScreen(),
    const ClientBookingListScreen(),
    const ProfileScreen(),
  ];

  chooseBottomNavIndex(int index) {
    emit(ChooseBottomNavState(
      index,
      (complete) {
        if (complete) {
          bottomNavIndex = index;
        }
      },
    ));
  }

  getHomeData() {
    emit(GetBestDealsLoadingState());
    _rentalService.getBestDeals().then((value) {
      bestDealsRentals = [];
      for (var element in value.result!) {
        bestDealsRentals.add(element);
        emit(GetBestDealsSuccessState());
      }
      if (bestDealsRentals.isNotEmpty) {
        firstBestDeals = bestDealsRentals.getRange(0, 3).toList();
      }
    }).then((value) {
      getMostRecentData();
    }).then((value) {
      getTopBrandsData();
    }).then((value) {
      getFeaturedDealersData();
    }).catchError((error) {
      throw error;
    });
  }

  getMostRecentData() {
    emit(GetMostRecentLoadingState());
    _rentalService
        .getFilteredRentals(RentalFilterModel(
      minPrice: 0,
      maxPrice: 0,
      latitude: 0,
      longitude: 0,
      radius: 0,
      paginationModel: PaginationModel(
        pageNumber: 0,
        pageSize: 5,
      ),
      sort: Sort(
        sortBy: "Date",
        sortOrder: "DESC",
      ),
    ))
        .then((value) {
      mostRecentRentals = [];
      for (var element in value.result!) {
        mostRecentRentals.add(element);
        emit(GetMostRecentSuccessState());
      }
    }).catchError((error) {
      emit(GetMostRecentErrorState());
    });
  }

  getTopBrandsData() {
    emit(GetTopBrandsLoadingState());
    _carService.getTopBrands().then((value) {
      topBrandsList = [];
      for (var element in value.result!) {
        topBrandsList.add(element);
        emit(GetTopBrandsSuccessState());
      }
    }).catchError((error) {
      emit(GetTopBrandsErrorState());
    });
  }

  getFeaturedDealersData() {
    emit(GetFeaturedDealersLoadingState());
    _rentalService.getFeaturedDealers().then((value) {
      for (var element in value) {
        featuredDealersList = [];
        featuredDealersList.add(element);
        emit(GetFeaturedDealersSuccessState());
      }
    }).catchError((error) {
      emit(GetFeaturedDealrsErrorState());
    });
  }
}
