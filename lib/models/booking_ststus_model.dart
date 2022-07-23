import 'package:rentx/extensions/string_extension.dart';
import 'package:rentx/infrastructure/request.dart';
import 'package:rentx/infrastructure/utils.dart';
import 'package:rentx/models/booking_model.dart';

class ChangeBookingStatusRequest extends RentXSerialized {
  String? rejectReason;
  String? description;
  BookingStatus? status;

  ChangeBookingStatusRequest(
      {this.rejectReason, this.description, this.status});

  ChangeBookingStatusRequest.fromJson(Map<String, dynamic> json) {
    rejectReason = json['rejectReason'];
    description = json['description'];
    status = EnumUtil.strToEnumNullable(BookingStatus.values, json['status']);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rejectReason'] = rejectReason;
    data['description'] = description;
    data['status'] = status?.name.capitalize();
    return data;
  }
}
