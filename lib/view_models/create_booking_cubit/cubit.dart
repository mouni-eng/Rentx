import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentx/models/booking_model.dart';
import 'package:rentx/models/create_booking_model.dart';
import 'package:rentx/models/rental_details_model.dart';
import 'package:rentx/services/auth_service.dart';
import 'package:rentx/services/booking_service.dart';
import 'package:rentx/services/alert_service.dart';
import 'package:rentx/view_models/create_booking_cubit/states.dart';

class CreateBookingCubit extends Cubit<CreateBookingStates> {
  CreateBookingCubit() : super(CreateBookingStates());

  static CreateBookingCubit get(context) => BlocProvider.of(context);

  final BookingService _bookingService = BookingService();
  RentalDetailsResult? model;

  init(RentalDetailsResult rentalModel) {
    model = rentalModel;
  }

  String? email, confirmEmail, phoneNumber, name, surName;

  changeName(String value) {
    name = value;
    emit(OnChooseValueState());
  }

  changeSurName(String value) {
    surName = value;
    emit(OnChooseValueState());
  }

  changeEmail(String value) {
    email = value;
    emit(OnChooseValueState());
  }

  changeConfirmEmail(String value) {
    confirmEmail = value;
    emit(OnChooseValueState());
  }

  changePhoneNumber(String value) {
    phoneNumber = value;
    emit(OnChooseValueState());
  }

  createBooking() {
    emit(BookingCreationLoadingState());
    var createBookingModel = CreateBookingModel(
      rentalId: model!.id,
      fromDate: DateTime.now(),
      toDate: DateTime.now(),
      price: model!.price,
      paymentMethod: PaymentMethod.cash,
      user: User(
        name: name,
        surName: surName,
        email: email,
        confirmEmail: confirmEmail,
        phoneNumber: phoneNumber,
      ),
    );
    if (AuthService.isLoggedIn) {
      _bookingService
          .createBooking(createBookingModel)
          .then((value) => emit(BookingCreatedState()))
          .catchError((error) =>
              emit(BookingCreationError(ErrorService.defineError(error))));
    } else {
      _bookingService
          .createGuestBooking(createBookingModel)
          .then((value) => emit(BookingCreatedState()))
          .catchError((error) =>
              emit(BookingCreationError(ErrorService.defineError(error))));
    }
  }
}
