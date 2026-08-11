import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/payroll_period_model.dart';

abstract final class TeacherPayrollPresenter {
  static DateTime? _date(String value) => DateTime.tryParse(value);

  static String range(BuildContext context, PayrollPeriodModel period) {
    final from = _date(period.from), to = _date(period.to);
    if (from == null || to == null) return '${period.from} — ${period.to}';
    final locale = Localizations.localeOf(context).languageCode;
    return '${DateFormat.yMMMMd(locale).format(from)} — '
        '${DateFormat.yMMMMd(locale).format(to)}';
  }

  static String? month(BuildContext context, PayrollPeriodModel period) {
    final from = _date(period.from), to = _date(period.to);
    if (from == null || to == null) return null;
    final last = DateTime(from.year, from.month + 1, 0).day;
    if (from.day != 1 || to.day != last || from.month != to.month) return null;
    return DateFormat.MMMM(
      Localizations.localeOf(context).languageCode,
    ).format(from);
  }

  static String paidAt(BuildContext context, String value) {
    final date = _date(value);
    return date == null
        ? value
        : DateFormat.yMMMMd(
            Localizations.localeOf(context).languageCode,
          ).format(date);
  }
}
