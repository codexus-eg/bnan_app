import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/classrooms_management/data/models/classroom_model.dart';
import 'package:bnan_app/features/plans/presentation/manager/get_term_plans/get_term_plans_cubit.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TermPlansDropdown extends StatelessWidget {
  const TermPlansDropdown({super.key, required this.classrooms});

  static const allValue = '__all_classrooms__';
  final List<ClassroomModel> classrooms;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<GetTermPlansCubit>();
    return CustomDropdown(
      label: S.of(context).classroom,
      value: cubit.selectedClassroomId ?? allValue,
      hint: S.of(context).selectClassroom,
      items: [allValue, ...classrooms.map((item) => item.id)],
      itemsLabels: {
        allValue: S.of(context).allClassrooms,
        for (final item in classrooms) item.id: item.name,
      },
      backgroundColor: ColorManager.white,
      onChanged: (value) =>
          cubit.selectClassroom(value == allValue ? null : value),
    );
  }
}
