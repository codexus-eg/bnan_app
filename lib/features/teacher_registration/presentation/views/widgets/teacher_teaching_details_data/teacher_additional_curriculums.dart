import 'package:bnan_app/core/shared_widget/custom_option_tile.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/get_curriculums_cubit/get_curriculums_cubit.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/get_curriculums_cubit/get_curriculums_state.dart';
import 'package:bnan_app/features/teacher_registration/presentation/manager/teacher_registration_cubit/teacher_registration_cubit.dart';
import 'package:bnan_app/features/teacher_registration/presentation/manager/teacher_registration_cubit/teacher_registration_state.dart';
import 'package:bnan_app/features/teacher_registration/presentation/views/widgets/teacher_shared_widgets/teacher_yes_no_question/teacher_question_title.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherAdditionalCurriculums extends StatelessWidget {
  const TeacherAdditionalCurriculums({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeacherRegistrationCubit, TeacherRegistrationState>(
      builder: (context, teacherState) =>
          BlocBuilder<GetCurriculumsCubit, GetCurriculumsState>(
            builder: (context, state) {
              final cubit = TeacherRegistrationCubit.get(context);
              final items = state is GetCurriculumsSuccess
                  ? state.curriculums
                        .where((item) => item.id != cubit.selectedCurriculumId)
                        .toList()
                  : const [];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TeacherQuestionTitle(
                    question: S.of(context).additionalCurriculums,
                    isRequired: true,
                  ),
                  const SizedBox(height: 12),
                  for (final item in items)
                    CustomOptionTile(
                      title: item.name,
                      isSelected: cubit.additionalCurriculumIds.contains(
                        item.id,
                      ),
                      onTap: () => cubit.toggleAdditionalCurriculum(item.id),
                    ),
                ],
              );
            },
          ),
    );
  }
}
