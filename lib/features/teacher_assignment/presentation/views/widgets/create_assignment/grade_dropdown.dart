import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/features/teacher_assignment/data/model/teacher_grades_response_model.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/create_assignment/create_assignment_cubit.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_teacher_grades/get_teacher_grades_cubit.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_teacher_grades/get_teacher_grades_state.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/views/widgets/create_assignment/dropdown_hint_style.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GradeDropdown extends StatelessWidget {
  const GradeDropdown({super.key});
  //TODO remove
  @override
  Widget build(BuildContext context) {
    final createCubit = context.watch<CreateAssignmentCubit>();

    return BlocBuilder<GetTeacherGradesCubit, GetTeacherGradesState>(
      builder: (context, state) {
        final grades = state is GetTeacherGradesSuccess
            ? state.grades.grades
            : TeacherGradesResponseModel.placeholder().grades;

        return CustomDropdown(
          label: S.of(context).grade,
          isRequired: true,
          hint: S.of(context).grade,
          hintStyle: dropdownHintStyle(context),
          value: createCubit.selectedGradeId,
          items: grades.map((item) => item.name).toList(),
          itemsLabels: {for (final item in grades) item.id: item.name},
          onChanged: createCubit.changeGrade,
        );
      },
    );
  }
}
