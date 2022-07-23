import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rentx/infrastructure/exceptions.dart';
import 'package:rentx/infrastructure/localizations/language.dart';
import 'package:rentx/infrastructure/localizations/translator.dart';

void printLn(Object? object) {
  if (kDebugMode) {
    print(object);
  }
}

class DateUtil {
  static strDate(final DateTime? dateTime) {
    if (dateTime == null) return '';
    return '${dateTime.day}/${dateTime.month + 1}/${dateTime.year}';
  }

  static displayDiffrence(final DateTime from, final DateTime to) {
    return " x ${from.day - to.day} Days";
  }

  static displayRange(final DateTime from, final DateTime to) {
    if (from.isAfter(to)) {
      throw 'Invalid date range: from cannot be after to';
    }
    if (_isSameDate(from, to)) {
      return '${_labeledDay(from.day.toString())} ${_labeledMonth(from.month)} ${from.year}';
    }

    if (_isSameMonthYear(from, to)) {
      return '${from.day}-${_labeledDay(to.day.toString())} ${_labeledMonth(from.month)} ${from.year}';
    }

    if (_isSameYear(from, to)) {
      return '${from.day} ${_labeledMonth(from.month)}-${_labeledDay(to.day.toString())} ${_labeledMonth(to.month)} ${from.year}';
    }

    return '${from.day}/${from.month}/${from.year} - ${to.day}/${to.month}/${to.year}';
  }

  static bool _isSameDate(DateTime from, DateTime to) {
    return from.day == to.day && _isSameMonthYear(from, to);
  }

  static _labeledDay(String day) {
    if (Language.currentLanguage.locale.languageCode == 'al') return day;
    if (day.endsWith('1')) return day + 'st';
    if (day.endsWith('2')) return day + 'nd';
    if (day.endsWith('3')) return day + 'rd';
    return day + 'th';
  }

  static String _getMonthStr(int month) {
    switch (month) {
      case 1:
        return 'month.january';
      case 2:
        return 'month.february';
      case 3:
        return 'month.march';
      case 4:
        return 'month.april';
      case 5:
        return 'month.may';
      case 6:
        return 'month.june';
      case 7:
        return 'month.july';
      case 8:
        return 'month.august';
      case 9:
        return 'month.september';
      case 10:
        return 'month.october';
      case 11:
        return 'month.november';
      case 12:
        return 'month.december';
    }
    throw BusinessException('invalid-month', 'invalid month index: $month');
  }

  static _labeledMonth(int month) {
    return Translator.translate(_getMonthStr(month));
  }

  static bool _isSameMonthYear(DateTime from, DateTime to) {
    return from.month == to.month && _isSameYear(from, to);
  }

  static bool _isSameYear(DateTime from, DateTime to) {
    return from.year == to.year;
  }
}

class EnumUtil {
  static T strToEnum<T extends Enum>(List<T> values, String str) {
    return values.firstWhere((element) => str.toLowerCase() == element.name);
  }

  static T? strToEnumNullable<T extends Enum>(List<T> values, String? str) {
    return str != null ? strToEnum(values, str) : null;
  }
}

class ZipUtil {
  static int? parseZip(String? zip) {
    if (zip == null) {
      return null;
    }
    if (zip.contains('-')) {
      return int.parse(zip.split('-')[0]);
    }
    return int.parse(zip);
  }
}

class NameUtil {
  static String getInitials(final String? name, final String? surname) {
    return ((name?.substring(0, 1) ?? '') + (surname?.substring(0, 1) ?? ''))
        .toUpperCase();
  }

  static String getFullName(final String? name, final String? surname) {
    return "$name $surname";
  }
}

Widget? modelToWidget<T>(T? model, Widget Function(T) mapper) {
  return model != null ? mapper.call(model) : null;
}

class NumberUtil {
  static T getLower<T extends num>(T num1, T num2) {
    return num1 <= num2 ? num1 : num2;
  }

  static String padNumber(num num, {String? left = '0', int length = 0}) {
    if (num == 0) return '0';
    final String strNum = num.toString();
    if (length == 0 || length < strNum.length) return strNum;
    String padded = '';
    for (int i = 0; i < length - strNum.length; i++) {
      padded += left!;
    }
    return padded + strNum;
  }
}
