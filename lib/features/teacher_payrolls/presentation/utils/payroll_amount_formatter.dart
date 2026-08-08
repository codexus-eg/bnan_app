import 'package:intl/intl.dart';

abstract final class PayrollAmountFormatter {
  static String format(num value) => NumberFormat('0.00', 'en').format(value);
}
