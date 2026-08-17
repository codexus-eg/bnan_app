import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/dashboard/data/models/student_dashboard_subscription.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class MonthlySubscriptionInfo extends StatelessWidget {
  const MonthlySubscriptionInfo({super.key, required this.subscription});
  final DashboardSubscription subscription;
  static const _white = ColorManager.white;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Column(
      children: [
        _line(context, s.packageName, subscription.packageName),
        _line(context, s.packageDuration, '${subscription.purchasedMonths}'),
        _line(context, s.startDate, _date(subscription.startDate)),
        _line(context, s.endDate, _date(subscription.endDate)),
        if (subscription.remainingType.trim().toLowerCase() == 'days' &&
            subscription.remainingValue != null)
          _line(context, s.remainingDays(subscription.remainingValue!), ''),
      ],
    );
  }

  Widget _line(BuildContext context, String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: StylesManager.styleRegular12(
              context,
            ).copyWith(color: _white),
          ),
        ),
        if (value.isNotEmpty)
          Text(
            value,
            style: StylesManager.styleBold12(context).copyWith(color: _white),
          ),
      ],
    ),
  );

  String _date(DateTime? value) =>
      value?.toLocal().toIso8601String().split('T').first ?? '-';
}
