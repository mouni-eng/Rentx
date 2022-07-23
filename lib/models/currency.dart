import 'package:rentx/infrastructure/utils.dart';

enum Currency { eur, usd, all }

class CurrencyRate {
  late Currency from;
  late Currency to;
  late num rate;

  CurrencyRate({required this.from, required this.to, required this.rate});

  CurrencyRate.fromJson(Map<String, dynamic> json) {
    from = EnumUtil.strToEnum(Currency.values, json['from']);
    to = EnumUtil.strToEnum(Currency.values, json['to']);
    rate = json['rate'];
  }
}

class CurrencyValue {
  final Currency currency;
  final double value;

  CurrencyValue({required this.currency, required this.value});
}

extension CurrencyExtension on Currency {
  String get symbol {
    switch (this) {
      case Currency.usd:
        return '\$';
      case Currency.eur:
        return '€';
      case Currency.all:
        return 'L';
    }
  }
}
