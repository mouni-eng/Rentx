class SearchStates {}

class SearchLoadingState extends SearchStates {}

class OnChangeLocationState extends SearchStates {}

class OnChangeCalanderState extends SearchStates {}

class GetMapRentalsSuccessState extends SearchStates {}

class GetMapRentalsLoadingState extends SearchStates {}

class GetMapRentalsErrorState extends SearchStates {}

class GpsErrorState extends SearchStates {
  final String error;

  GpsErrorState(this.error);
}
