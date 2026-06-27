import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/features/teacher_assignment/data/model/teacher_curriculum_model.dart';
import 'package:bnan_app/features/teacher_assignment/data/model/teacher_curriculum_response_model.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/create_assignment/create_assignment_cubit.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_teacher_curriculums/get_teacher_curriculums_cubit.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_teacher_curriculums/get_teacher_curriculums_state.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_teacher_grades/get_teacher_grades_cubit.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/views/widgets/create_assignment/dropdown_hint_style.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CurriculumDropdown extends StatelessWidget {
  const CurriculumDropdown({super.key});
//TODO remove
  @override
  Widget build(BuildContext context) {
    final createCubit = context.watch<CreateAssignmentCubit>();

    return BlocBuilder<GetTeacherCurriculumsCubit, GetTeacherCurriculumsState>(
      builder: (context, state) {
        final List<TeacherCurriculumModel> curriculums= state is GetTeacherCurriculumsSuccess
            ? state.curriculums.curriculums
                : TeacherCurriculumsResponseModel.placeholder().curriculums;

        return CustomDropdown(
          label: S.of(context).curriculum,
          isRequired: true,
          hint: S.of(context).curriculum,
          hintStyle: dropdownHintStyle(context),
          value: createCubit.selectedCurriculumId,
          items: curriculums.map((item) => item.id).toList(),
          itemsLabels: {for (final item in curriculums) item.id: item.name},

          onChanged: (value) {
            createCubit.changeCurriculum(value);
            context.read<GetTeacherGradesCubit>().getGradesByCurriculum(
              curriculumId: value ?? '',
            );
          },
        );
      },
    );
  }
}
