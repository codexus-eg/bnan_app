import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/plans/presentation/models/plans_access_policy.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class PlansFiltersSection extends StatelessWidget {
  const PlansFiltersSection({
    super.key,
    required this.policy,
    required this.classroom,
    required this.week,
    required this.onClassroomChanged,
    required this.onWeekChanged,
  });

  final PlansAccessPolicy policy;
  final String? classroom;
  final String? week;
  final ValueChanged<String?> onClassroomChanged;
  final ValueChanged<String?> onWeekChanged;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final fields = _fields(context);
        if (fields.length == 1) {
          return Align(
            alignment: AlignmentDirectional.centerStart,
            child: SizedBox(
              width: constraints.maxWidth.clamp(0, 180).toDouble(),
              child: fields.first,
            ),
          );
        }
        if (constraints.maxWidth < 300) {
          return Column(
            children: [fields.first, const SizedBox(height: 12), fields.last],
          );
        }
        return Row(
          children: [
            Expanded(child: fields.first),
            const SizedBox(width: 16),
            Expanded(child: fields.last),
          ],
        );
      },
    );
  }

  List<Widget> _fields(BuildContext context) {
    final s = S.of(context);
    return [
      if (policy.showClassroomFilter)
        CustomDropdown(
          label: s.grade,
          value: classroom,
          hint: s.chooseGrade,
          items: const ['first', 'second'],
          itemsLabels: {
            'first': s.firstPrimaryClassroom,
            'second': s.secondPrimaryClassroom,
          },
          backgroundColor: ColorManager.white,
          onChanged: onClassroomChanged,
        ),
      if (policy.showWeekFilter)
        CustomDropdown(
          label: s.week,
          value: week,
          hint: s.selectWeek,
          items: const ['week1', 'week2'],
          itemsLabels: {'week1': s.weekOne, 'week2': s.weekTwo},
          backgroundColor: ColorManager.white,
          onChanged: onWeekChanged,
        ),
    ];
  }
}
