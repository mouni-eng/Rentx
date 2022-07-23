import 'package:rentx/infrastructure/http_service.dart';
import 'package:rentx/infrastructure/local_storage.dart';
import 'package:rentx/infrastructure/utils.dart';
import 'package:rentx/models/currency.dart';

class CurrencyService {
  final HttpService _httpService = HttpService();
  final LocalStorage _localStorage = LocalStorage();

  static Map<Currency, CurrencyRate> cachedRates = {};
  static Currency selectedCurrency = Currency.eur;

  Future<CurrencyRate> getRate(final Currency from, final Currency to) async {
    if (to == Currency.eur) {
      return CurrencyRate(from: from, to: to, rate: 1.0);
    }
    if (cachedRates.containsKey(to)) {
      return cachedRates[to]!;
    }
    var resp = await _httpService.doGet(
        '/currency/rate?fromCurrency=${from.name}&toCurrency=${to.name}');
    var rate = CurrencyRate.fromJson(resp['result']);
    cachedRates.putIfAbsent(to, () => rate);
    return rate;
  }

  Future<Currency> getCurrency() async {
    final activeCurrency =
        await _localStorage.getString(LocalStorageKeys.currency);
    if (activeCurrency == null) {
      return switchCurrency(Currency.eur);
    }
    selectedCurrency = EnumUtil.strToEnum(Currency.values, activeCurrency);
    return selectedCurrency;
  }

  Future<Currency> switchCurrency(final Currency currency) async {
    await _localStorage.setString(LocalStorageKeys.currency, currency.name);
    selectedCurrency = currency;
    return currency;
  }

  Future<CurrencyValue> getConvertedAmount(final double price) async {
    if (price == 0) {
      return CurrencyValue(currency: await getCurrency(), value: 0);
    }
    final CurrencyRate rate = await getRate(Currency.eur, await getCurrency());
    return CurrencyValue(currency: rate.to, value: rate.rate * price);
  }
}
