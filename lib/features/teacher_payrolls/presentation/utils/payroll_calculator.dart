import 'package:bnan_app/features/teacher_payrolls/data/models/payroll_work_item_model.dart';

abstract final class PayrollCalculator {
  static double item(PayrollWorkItemModel work, double rate) =>
      work.minutes * rate / 60;
  static double total(
    Iterable<PayrollWorkItemModel> work,
    Map<String, double> rates,
    double bonus,
    double deduction,
  ) =>
      work.fold<double>(
        0,
        (sum, item) =>
            sum + PayrollCalculator.item(item, rates[item.gradeId] ?? 0),
      ) +
      bonus -
      deduction;
}
