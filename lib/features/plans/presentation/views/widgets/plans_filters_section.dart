import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/plans/presentation/policies/plans_access_policy.dart';
import 'package:bnan_app/features/plans/presentation/models/plan_classroom_option.dart';
import 'package:bnan_app/features/plans/data/models/parent_plan_child_model.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class PlansFiltersSection extends StatelessWidget {
  const PlansFiltersSection({
    super.key,
    required this.policy,
    required this.classroom,
    required this.classrooms,
    required this.classroomHint,
    required this.week,
    required this.weeks,
    required this.weekHint,
    required this.onClassroomChanged,
    required this.onWeekChanged,
    this.children = const [],
    this.selectedChildId,
    this.childHint,
    this.onChildChanged,
  });

  final PlansAccessPolicy policy;
  final PlanClassroomOption? classroom;
  final List<PlanClassroomOption>? classrooms;
  final String classroomHint;
  final int? week;
  final List<int>? weeks;
  final String weekHint;
  final ValueChanged<PlanClassroomOption?> onClassroomChanged;
  final ValueChanged<int?> onWeekChanged;
  final List<ParentPlanChildModel> children;
  final String? selectedChildId;
  final String? childHint;
  final ValueChanged<String?>? onChildChanged;

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
            Expanded(flex: 3, child: fields.first),
            const SizedBox(width: 20),
            Expanded(flex: 2, child: fields.last),
          ],
        );
      },
    );
  }

  List<Widget> _fields(BuildContext context) {
    final s = S.of(context);
    return [
      if (policy.showChildFilter)
        CustomDropdown(
          label: s.child,
          value: selectedChildId,
          hint: childHint ?? s.selectChild,
          items: children.map((item) => item.id).toList(),
          itemsLabels: {for (final item in children) item.id: item.fullName},
          valueStyle: StylesManager.styleRegular16(
            context,
          ).copyWith(color: ColorManager.mainColor14),
          backgroundColor: ColorManager.white,
          onChanged: onChildChanged,
        ),
      if (policy.showClassroomFilter)
        CustomDropdown(
          label: s.classRoom,
          value: classroom?.id,
          hint: classroomHint,
          items: classrooms?.map((item) => item.id).toList(),
          itemsLabels: {
            for (final item in classrooms ?? const <PlanClassroomOption>[])
              item.id: item.name,
          },
          valueStyle: StylesManager.styleRegular16(
            context,
          ).copyWith(color: ColorManager.mainColor14),
          backgroundColor: ColorManager.white,
          onChanged: (id) => onClassroomChanged(
            classrooms?.where((item) => item.id == id).firstOrNull,
          ),
        ),
      if (policy.showWeekFilter)
        CustomDropdown(
          label: s.week,
          value: week?.toString(),
          hint: weekHint,
          items: weeks?.map((item) => item.toString()).toList(),
          itemsLabels: {
            for (final item in weeks ?? const <int>[])
              item.toString(): '${s.week} $item',
          },
          backgroundColor: ColorManager.white,
          onChanged: (value) => onWeekChanged(int.tryParse(value ?? '')),
          valueStyle: StylesManager.styleRegular16(
            context,
          ).copyWith(color: ColorManager.mainColor14),
        ),
    ];
  }
}
