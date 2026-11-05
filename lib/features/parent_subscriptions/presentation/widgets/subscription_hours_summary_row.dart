import 'package:bnan_app/core/helper/subscription_hours_formatter.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class SubscriptionHoursSummaryRow extends StatelessWidget {
  const SubscriptionHoursSummaryRow({
    super.key,
    required this.purchasedHours,
    required this.usedHours,
    required this.remainingHours,
  });

  final num purchasedHours, usedHours, remainingHours;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Row(
      children: [
        _box(
          context,
          s.renewalPurchasedHours,
          SubscriptionHoursFormatter.formatTotalHours(
            purchasedHours,
            context: context,
          ),
        ),
        const SizedBox(width: 8),
        _box(
          context,
          s.renewalUsedHours,
          SubscriptionHoursFormatter.formatHours(
            usedHours,
            context: context,
            isRemaining: false,
          ),
        ),
        const SizedBox(width: 8),
        _box(
          context,
          s.renewalRemainingHours,
          SubscriptionHoursFormatter.formatHours(
            remainingHours,
            context: context,
            isRemaining: true,
          ),
        ),
      ],
    );
  }

  Widget _box(BuildContext context, String title, String value) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      decoration: BoxDecoration(
        color: ColorManager.greyF4F6,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: ColorManager.borderColor),
      ),
      child: Column(
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: StylesManager.styleRegular12(
              context,
            ).copyWith(color: ColorManager.grey7A7C, fontSize: 10),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: StylesManager.styleBold12(
              context,
            ).copyWith(color: ColorManager.mainColor14, fontSize: 11),
          ),
        ],
      ),
    ),
  );
}
