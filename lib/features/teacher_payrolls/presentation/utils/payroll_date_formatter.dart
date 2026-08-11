import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

abstract final class PayrollDateFormatter {
  static String range(BuildContext context, DateTime from, DateTime to) {
    final locale = Localizations.localeOf(context).languageCode;
    final pattern = locale == 'ar' ? 'd MMMM y' : 'MMM d, y';
    final formatter = DateFormat(pattern, locale);
    return '${formatter.format(from)} — ${formatter.format(to)}';
  }

  static String field(DateTime value) =>
      DateFormat('dd/MM/yyyy', 'en').format(value);
}
