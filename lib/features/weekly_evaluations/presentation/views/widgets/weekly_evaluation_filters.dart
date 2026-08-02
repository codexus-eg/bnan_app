import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/plans/presentation/models/plan_classroom_option.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/manager/weekly_evaluations_cubit.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class WeeklyEvaluationFilters extends StatelessWidget {
  const WeeklyEvaluationFilters({
    super.key,
    required this.cubit,
    this.classrooms,
  });
  final WeeklyEvaluationsCubit cubit;
  final List<PlanClassroomOption>? classrooms;

  @override
  Widget build(BuildContext context) {
    final fields = <Widget>[
      if (cubit.canManage) _classroom(context),
      if (cubit.isParent && cubit.hasMultipleChildren) _child(context),
      _week(context),
    ];
    if (fields.length == 1) {
      return Align(
        alignment: AlignmentDirectional.centerStart,
        child: SizedBox(width: 160, child: fields.first),
      );
    }
    return Row(
      children: [
        for (var i = 0; i < fields.length; i++) ...[
          Expanded(flex: i == 0 ? 3 : 2, child: fields[i]),
          if (i < fields.length - 1) const SizedBox(width: 16),
        ],
      ],
    );
  }

  Widget _classroom(BuildContext context) => CustomDropdown(
    label: S.of(context).classRoom,
    value: cubit.selectedClassroom?.id,
    hint: S.of(context).selectClassroom,
    items: classrooms?.map((item) => item.id).toList(),
    itemsLabels: {
      for (final item in classrooms ?? const <PlanClassroomOption>[])
        item.id: item.name,
    },
    backgroundColor: ColorManager.white,
    onChanged: (id) => cubit.selectClassroom(
      classrooms?.where((item) => item.id == id).firstOrNull,
    ),
  );

  Widget _child(BuildContext context) => CustomDropdown(
    label: S.of(context).child,
    value: cubit.selectedChildId,
    hint: S.of(context).selectChild,
    items: cubit.children.map((item) => item.id).toList(),
    itemsLabels: {for (final item in cubit.children) item.id: item.fullName},
    backgroundColor: ColorManager.white,
    onChanged: cubit.selectChild,
  );

  Widget _week(BuildContext context) => CustomDropdown(
    label: S.of(context).week,
    value: cubit.selectedWeek?.toString(),
    hint: S.of(context).selectWeek,
    items: cubit.availableWeeks.map((item) => '$item').toList(),
    itemsLabels: {
      for (final item in cubit.availableWeeks)
        '$item': '${S.of(context).week} $item',
    },
    backgroundColor: ColorManager.white,
    onChanged: (value) => cubit.selectWeek(int.tryParse(value ?? '')),
  );
}
