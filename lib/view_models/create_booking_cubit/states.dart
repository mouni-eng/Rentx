class CreateBookingStates {}

class OnChooseValueState extends CreateBookingStates {}

class BookingCreationLoadingState extends CreateBookingStates {}

class BookingCreatedState extends CreateBookingStates {}

class BookingCreationError extends CreateBookingStates {
  final String error;

  BookingCreationError(this.error);
}
