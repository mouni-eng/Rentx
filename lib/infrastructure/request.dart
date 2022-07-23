import 'package:flutter/material.dart';

abstract class RentXSerialized {
  Map<String, dynamic> toJson();

  @protected
  DateTime? parseDate(String? strDate) {
    return strDate == null || strDate.isEmpty ? null : DateTime.parse(strDate);
  }

  @protected
  List<T> convertList<T>(List<dynamic>? inpList, T Function(dynamic) func) {
    if (inpList == null || inpList.isEmpty) return [];
    return inpList.map((e) => func.call(e)).toList();
  }

  void ifNotNull(dynamic value, Function() mapper) {
    if (value != null) {
      mapper.call();
    }
  }
}
