import 'package:bnan_app/features/auth/data/models/subscription_plan_model.dart';
import 'package:bnan_app/features/auth/presentation/views/widgets/subscription_widgets/subscription_plan_card.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class SubscriptionGrid extends StatelessWidget {
  const SubscriptionGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final plans = _plans(context);

    return SliverList.separated(
      itemCount: (plans.length / 2).ceil(),
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, rowIndex) {
        final firstIndex = rowIndex * 2;
        final secondIndex = firstIndex + 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: SubscriptionPlanCard(plan: plans[firstIndex])),
            const SizedBox(width: 19),
            if (secondIndex < plans.length)
              Expanded(child: SubscriptionPlanCard(plan: plans[secondIndex]))
            else
              const Spacer(),
          ],
        );
      },
    );
  }

  List<SubscriptionPlanModel> _plans(BuildContext context) {
    return [
      SubscriptionPlanModel(
        title: S.of(context).fourHoursPlan,
        hours: S.of(context).trainingHours('4'),
        lessons: S.of(context).weeklyLessons('4'),
        oldPrice: S.of(context).oldPrice('200'),
        price: S.of(context).currentPrice('160'),
        save: S.of(context).saveAmount('40'),
      ),
      SubscriptionPlanModel(
        title: S.of(context).eightHoursPlan,
        hours: S.of(context).trainingHours('8'),
        lessons: S.of(context).weeklyLessons('3'),
        oldPrice: S.of(context).oldPrice('380'),
        price: S.of(context).currentPrice('300'),
        save: S.of(context).saveAmount('80'),
      ),
      SubscriptionPlanModel(
        title: S.of(context).twelveHoursPlan,
        hours: S.of(context).trainingHours('12'),
        lessons: S.of(context).weeklyLessons('12'),
        oldPrice: S.of(context).oldPrice('540'),
        price: S.of(context).currentPrice('420'),
        save: S.of(context).saveAmount('120'),
        isPopular: true,
      ),
      SubscriptionPlanModel(
        title: S.of(context).twentyHoursPlan,
        hours: S.of(context).trainingHours('20'),
        lessons: S.of(context).weeklyLessons('20'),
        oldPrice: S.of(context).oldPrice('860'),
        price: S.of(context).currentPrice('660'),
        save: S.of(context).saveAmount('200'),
      ),
    ];
  }
}