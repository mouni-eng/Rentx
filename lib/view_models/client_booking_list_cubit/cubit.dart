import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentx/models/booking_model.dart';
import 'package:rentx/services/booking_service.dart';
import 'package:rentx/services/user_service.dart';

import 'states.dart';

class ClientBookingsCubit extends Cubit<ClientBookingStates> {
  ClientBookingsCubit() : super(ClientBookingStates());

  static ClientBookingsCubit get(context) => BlocProvider.of(context);

  final UserService _userService = UserService();

  bool toggleShowAllActive = false;
  bool toggleShowAllPrevious = false;

  List<UserBooking> availableBookings = [];
  List<UserBooking> pastBookings = [];

  getBookings() {
    emit(BookingsLoadingState());
    _userService.getUserBookings().then((value) {
      availableBookings = value.where((element) {
        DateTime now = DateTime.now();
        return element.toDate!.difference(now).inDays >= 0;
      }).toList();
      pastBookings = value.where((element) {
        DateTime now = DateTime.now();
        return element.toDate!.difference(now).inDays < 0;
      }).toList();
      emit(BookingsLoadedState());
    });
  }

  List<UserBooking> getActive() {
    return toggleShowAllActive || availableBookings.length < 2
        ? availableBookings
        : availableBookings.sublist(0, 2);
  }

  List<UserBooking> getPast() {
    return toggleShowAllPrevious || pastBookings.length < 2
        ? pastBookings
        : pastBookings.sublist(0, 2);
  }

  toggleViewAllActive() {
    toggleShowAllActive = !toggleShowAllActive;
    emit(ViewAllToggled());
  }

  toggleViewAllPrevious() {
    toggleShowAllPrevious = !toggleShowAllPrevious;
    emit(ViewAllToggled());
  }
}
