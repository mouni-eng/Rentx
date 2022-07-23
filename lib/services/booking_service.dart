import 'package:rentx/infrastructure/exceptions.dart';
import 'package:rentx/models/booking_model.dart';
import 'package:rentx/models/booking_ststus_model.dart';
import 'package:rentx/models/create_booking_model.dart';
import 'package:rentx/models/user.dart';
import 'package:rentx/services/auth_service.dart';
import 'package:rentx/services/rentx_service.dart';
import 'package:rentx/services/user_service.dart';

class BookingService extends RentXService {
  Future<ManagerBookingsModel> getBookingManagerData() async {
    var resp = await httpService.doGet("/company/bookings");
    return ManagerBookingsModel.fromJson(resp["result"]);
  }

  Future<CreateBookingResult> createGuestBooking(
      CreateBookingModel createBookingModel) async {
    var resp = await httpService.doPost(
        url: "/booking/guest/", rentXRequest: createBookingModel);
    return CreateBookingResult.fromJson(resp["result"]);
  }

  Future<CreateBookingResult> createBooking(
      CreateBookingModel createBookingModel) async {
    var resp = await httpService.doPost(
        url: "/booking/", rentXRequest: createBookingModel);
    await localStorage.remove(UserService.userBookings);
    return CreateBookingResult.fromJson(resp["result"]);
  }

  Future<ChangeBookingStatusRequest> updateStatus(
      String bookingId, ChangeBookingStatusRequest bookingStatusModel) async {
    var resp = await httpService.doPatch(
        url: "/booking/$bookingId/status", rentXRequest: bookingStatusModel);
    return ChangeBookingStatusRequest.fromJson(resp["result"]);
  }

  Future<CompanyBooking> getCompanyBookingDetails(final String id) async {
    if (AuthService.loggedUserRole != UserRole.manager) {
      throw BusinessException(
          'unauthorized', 'Not authorized to get company booking details');
    }
    var resp = await httpService.doGet('/bookings/$id}');
    return CompanyBooking.fromJson(resp['result']);
  }

  Future<UserBookingDetails> getUserBookingDetails(final String id) async {
    if (AuthService.loggedUserRole != UserRole.client) {
      throw BusinessException(
          'unauthorized', 'Not authorized to get client booking details');
    }
    var resp = await httpService.doGet('/booking/$id');
    return UserBookingDetails.fromJson(resp['result']);
  }
}
