import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
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
            children: [fields.first, const SizedBox(height: 20), fields.last],
          );
        }
        return Row(
          children: [
            Expanded(
              flex: 2,
              child: fields.first),
            const SizedBox(width: 20),
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
          valueStyle: StylesManager.styleRegular16(
            context,
          ).copyWith(color: ColorManager.mainColor14),
          backgroundColor: ColorManager.white,
          onChanged: onClassroomChanged,
        ),
      if (policy.showWeekFilter)
        CustomDropdown(
          label: s.week,
          value: week,
          hint: s.selectWeek,
          items: const ['week1', 'week2'],
          itemsLabels: {'week1':'week 1', 'week2': 'week 2'},
          backgroundColor: ColorManager.white,
          onChanged: onWeekChanged,
          valueStyle: StylesManager.styleRegular16(
            context,
          ).copyWith(color: ColorManager.mainColor14),
        ),
    ];
  }
}
