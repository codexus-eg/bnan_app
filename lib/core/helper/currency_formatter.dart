import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/widgets.dart';

abstract class CurrencyFormatter {
  static String symbol(BuildContext context, String? currency) =>
      symbolWith(S.of(context), currency);

  static String symbolWith(S strings, String? currency) =>
      switch (currency?.trim().toUpperCase()) {
        'EGP' => strings.egpShort,
        'SAR' => strings.sarShort,
        'QAR' => strings.qarShort,
        final code when code != null && code.isNotEmpty => code,
        _ => '',
      };

  static String amount(BuildContext context, num value, String? currency) {
    final number = value % 1 == 0 ? value.toInt().toString() : value.toString();
    return '$number ${symbol(context, currency)}'.trim();
  }
}
