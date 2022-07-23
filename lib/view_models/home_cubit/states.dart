class HomeStates {}

class ChooseBrandState extends HomeStates {}

class ChooseBottomNavState extends HomeStates {
  final int index;
  Function(bool) completeNavigation;

  ChooseBottomNavState(this.index, this.completeNavigation);
}

class ConvertCurrencyState extends HomeStates {}

class GetBestDealsLoadingState extends HomeStates {}

class GetBestDealsSuccessState extends HomeStates {}

class GetBestDealsErrorState extends HomeStates {}

class GetMostRecentLoadingState extends HomeStates {}

class GetMostRecentSuccessState extends HomeStates {}

class GetMostRecentErrorState extends HomeStates {}

class GetTopBrandsLoadingState extends HomeStates {}

class GetTopBrandsSuccessState extends HomeStates {}

class GetTopBrandsErrorState extends HomeStates {}

class GetFeaturedDealersLoadingState extends HomeStates {}

class GetFeaturedDealersSuccessState extends HomeStates {}

class GetFeaturedDealrsErrorState extends HomeStates {}

class OnChooseValueState extends HomeStates {}
