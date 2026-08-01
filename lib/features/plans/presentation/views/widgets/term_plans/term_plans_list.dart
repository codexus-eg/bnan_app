import 'package:bnan_app/features/plans/presentation/models/term_plan_card_item.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/term_plans/term_plan_card.dart';
import 'package:flutter/material.dart';

class TermPlansList extends StatelessWidget {
  const TermPlansList({super.key, required this.items});

  final List<TermPlanCardItem> items;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (_, index) => TermPlanCard(
        key: ValueKey(items[index].keyValue),
        item: items[index],
      ),
      separatorBuilder: (_, _) => const SizedBox(height: 16),
    );
  }
}
