import 'package:bnan_app/core/shared_widget/custom_option_tile.dart';
import 'package:bnan_app/features/student_auth/data/models/curriculum_model.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/get_grades_cubit/get_grades_cubit.dart';
import 'package:bnan_app/features/teacher_registration/presentation/manager/teacher_registration_cubit/teacher_registration_cubit.dart';
import 'package:bnan_app/features/teacher_registration/presentation/manager/teacher_registration_cubit/teacher_registration_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherCurriculumOptionsList extends StatelessWidget {
  const TeacherCurriculumOptionsList({
    super.key,
    required this.curriculums,
    required this.isLoading,
  });

  final List<CurriculumModel> curriculums;
  final bool isLoading;
  static final mockCurriculums = List.generate(
    3,
    (index) => CurriculumModel.mock({}),
  );
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeacherRegistrationCubit, TeacherRegistrationState>(
      builder: (context, state) {
        final teacherCubit = TeacherRegistrationCubit.get(context);
        final List<CurriculumModel> items = isLoading
            ? mockCurriculums
            : curriculums;
        return Column(
          children: List.generate(items.length, (index) {
            final curriculum = items[index];
            return CustomOptionTile(
              title: curriculum.name,
              isSelected:
                  !isLoading &&
                  teacherCubit.selectedCurriculumId == curriculum.id,
              onTap: isLoading
                  ? () {}
                  : () {
                      teacherCubit.changeTeachingCurriculum(
                        id: curriculum.id,
                        name: curriculum.name,
                      );
                      context.read<GetGradesCubit>().getCurriculumGrades(
                        curriculumId: curriculum.id,
                      );
                    },
            );
          }),
        );
      },
    );
  }
}
