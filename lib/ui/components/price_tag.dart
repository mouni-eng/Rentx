import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:rentx/models/currency.dart';
import 'package:rentx/services/currency_service.dart';
import 'package:rentx/ui/base_widget.dart';
import 'package:rentx/ui/components/custom_text.dart';

class PriceTag extends StatefulWidget {
  const PriceTag(
      {Key? key,
      required this.price,
      required this.fontSize,
      this.fontWeight,
      this.showPerDay = true,
      required this.color,
      this.ltr = true,
      this.suffix})
      : super(key: key);

  final double price;
  final double fontSize;
  final FontWeight? fontWeight;
  final Color color;
  final bool? ltr;

  final bool? showPerDay;
  final String? suffix;

  @override
  _PriceTagState createState() => _PriceTagState();
}

class _PriceTagState extends State<PriceTag> {
  final CurrencyService _currencyService = CurrencyService();

  CurrencyValue? _currencyValue;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return RentXWidget(
        builder: (rentXContext) => _priceTag(_currencyValue, rentXContext));
  }

  String _getPrice(CurrencyValue currencyValue) {
    return widget.ltr! ? _priceLtr(currencyValue) : _priceRtl(currencyValue);
  }

  String _formatPrice(num num) {
    if (num == 0) return '0';
    var formatter = NumberFormat('#,###.00');
    return formatter.format(num);
  }

  String _priceLtr(CurrencyValue currencyValue) {
    return '${currencyValue.currency.symbol} ${_formatPrice(currencyValue.value)}';
  }

  String _priceRtl(CurrencyValue currencyValue) {
    return '${_formatPrice(currencyValue.value)} ${currencyValue.currency.symbol}';
  }

  Widget _priceTag(CurrencyValue? currencyValue, RentXContext rentXContext) {
    String res = '...';
    if (currencyValue != null) {
      res = _getPrice(currencyValue);
      if (widget.showPerDay!) {
        res += ' /' + rentXContext.translate('day');
      }
    }
    return CustomText(
        color: widget.color,
        fontSize: widget.fontSize,
        fontWeight: widget.fontWeight,
        text: res + (widget.suffix ?? ''));
  }

  void _getData() {
    _currencyService.getConvertedAmount(widget.price).then((value) {
      setState(() {
        _currencyValue = value;
      });
    });
  }
}
