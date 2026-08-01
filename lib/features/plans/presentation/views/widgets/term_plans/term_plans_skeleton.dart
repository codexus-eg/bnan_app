import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/features/plans/presentation/models/term_plan_card_item.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/term_plans/term_plans_list.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class TermPlansSkeleton extends StatelessWidget {
  const TermPlansSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final items = List.generate(
      2,
      (index) => TermPlanCardItem(
        classroomName: S.of(context).classroom,
        subjectName: S.of(context).attachment,
        attachment: '',
        keyValue: 'skeleton-$index',
      ),
    );
    return AppSkeletonizer(isLoading: true, child: TermPlansList(items: items));
  }
}
