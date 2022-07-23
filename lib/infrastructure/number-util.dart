import 'package:intl/intl.dart';

String formatPrice(num num) {
  if (num == 0) return '0';
  var formatter = NumberFormat('#,###.00');
  return formatter.format(num);
}
