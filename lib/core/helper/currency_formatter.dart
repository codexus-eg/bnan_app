import 'package:flutter/widgets.dart';

abstract class CurrencyFormatter {
  static String symbol(BuildContext context, String? currency) =>
      code(currency);

  static String code(String? currency) => currency?.trim() ?? '';

  static String amount(BuildContext context, num value, String? currency) {
    final number = value % 1 == 0 ? value.toInt().toString() : value.toString();
    return '$number ${code(currency)}'.trim();
  }
}
