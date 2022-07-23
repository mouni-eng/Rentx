import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentx/models/booking_model.dart';
import 'package:rentx/models/booking_ststus_model.dart';
import 'package:rentx/services/booking_service.dart';
import 'package:rentx/ui/components/custom_dropdown_search.dart';
import 'package:rentx/view_models/booking_cubit/states.dart';

class BookingCubit extends Cubit<BookingStates> {
  BookingCubit() : super(BookingStates());

  static BookingCubit get(context) => BlocProvider.of(context);

  final BookingService _bookingService = BookingService();

  ManagerBookingsModel? bookingManagerModel;

  String? rangeDate;

  chooseRangeDate(String value) {
    rangeDate = value;
    emit(OnChangeRejectionState());
  }

  KeyValue<String>? rejectionModel;

  List<KeyValue<String>> rejectionList = [
    KeyValue(
      key: "unavailable",
      value: "carIsUnavailable",
    ),
    KeyValue(
      key: "service",
      value: "carIsOnService",
    ),
    KeyValue(
      key: "client-request",
      value: "requestedByClient",
    ),
    KeyValue(
      key: "other",
      value: "otherPleaseSpecify",
    ),
  ];

  chooseRejection(KeyValue<String> value) {
    rejectionModel = value;
    emit(OnChangeRejectionState());
  }

  String? description;

  onChangeDescription(String value) {
    description = value;
    emit(OnChangeRejectionState());
  }

  rejectConfirmation(String id) {
    emit(BookingConfirmLoadingState());
    _bookingService
        .updateStatus(
            id,
            ChangeBookingStatusRequest(
              status: BookingStatus.rejected,
              rejectReason: rejectionModel!.key,
              description: description,
            ))
        .then((value) {
      _resetBookingStatus(id, BookingStatus.rejected);
      rejectionModel = null;
      emit(BookingConfirmSuccessState());
    }).catchError((error) {
      emit(BookingConfirmErrorState());
    });
  }

  approveConfirmation(String id) {
    emit(BookingConfirmLoadingState());
    _bookingService
        .updateStatus(
            id, ChangeBookingStatusRequest(status: BookingStatus.approved))
        .then((value) {
      _resetBookingStatus(id, BookingStatus.approved);
      emit(BookingConfirmSuccessState());
    }).catchError((error) {
      emit(BookingConfirmErrorState());
    });
  }

  getBookings() {
    emit(GetBookingDataLoadingState());
    _bookingService.getBookingManagerData().then((value) {
      bookingManagerModel = value;
      emit(GetBookingDataSuccessState());
    }).catchError((error) {
      emit(GetBookingDataErrorState());
    });
  }

  _resetBookingStatus(String id, BookingStatus status) {
    bookingManagerModel!.bookings = bookingManagerModel!.bookings!.map((e) {
      if (e.id!.compareTo(id) == 0) {
        e.status = status;
      }
      return e;
    }).toList();
  }
}
