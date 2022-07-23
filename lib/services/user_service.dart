import 'package:rentx/models/booking_model.dart';
import 'package:rentx/services/rentx_service.dart';

class UserService extends RentXService {
  static const String userBookings = 'userBookings';

  Future<List<UserBooking>> getUserBookings() async {
    var resp = (await cacheOrGet(
            userBookings, () => httpService.doGet('/user/bookings')))['result']
        as List;
    return resp.map((e) => UserBooking.fromJson(e)).toList();
  }
}
