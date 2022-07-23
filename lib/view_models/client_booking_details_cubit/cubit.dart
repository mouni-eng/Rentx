import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentx/models/booking_model.dart';
import 'package:rentx/services/booking_service.dart';

import 'states.dart';

class ClientBookingDetailsCubit extends Cubit<ClientBookingDetailsStates> {
  ClientBookingDetailsCubit() : super(ClientBookingDetailsStates());

  static ClientBookingDetailsCubit get(context) => BlocProvider.of(context);

  final BookingService _bookingService = BookingService();
  UserBookingDetails? userBookingDetails;

  getBooking(UserBooking userBooking) {
    emit(BookingLoadingState());
    _bookingService.getUserBookingDetails(userBooking.id!).then((value) {
      userBookingDetails = value;
      userBookingDetails!.featuredImageUrl = userBooking.featuredImageUrl;
      emit(BookingLoadedState());
    });
  }
}
