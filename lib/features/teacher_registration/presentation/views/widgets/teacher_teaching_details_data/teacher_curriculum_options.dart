import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/features/student_auth/data/models/curriculum_model.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/get_curriculums_cubit/get_curriculums_cubit.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/get_curriculums_cubit/get_curriculums_state.dart';
import 'package:bnan_app/features/teacher_registration/presentation/views/widgets/teacher_shared_widgets/teacher_yes_no_question/teacher_question_title.dart';
import 'package:bnan_app/features/teacher_registration/presentation/views/widgets/teacher_teaching_details_data/teacher_curriculum_options_list.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherCurriculumOptions extends StatelessWidget {
  const TeacherCurriculumOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetCurriculumsCubit, GetCurriculumsState>(
      builder: (context, state) {
        final isLoading = state is GetCurriculumsLoading;
        final List<CurriculumModel> curriculums = state is GetCurriculumsSuccess
            ? state.curriculums
            : <CurriculumModel>[];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TeacherQuestionTitle(
              question: S.of(context).pleaseChooseTeachingCurriculum,
              isRequired: true,
            ),
            const SizedBox(height: 12),
            AppSkeletonizer(
              isLoading: isLoading,
              child: TeacherCurriculumOptionsList(
                curriculums: curriculums,
                isLoading: isLoading,
              ),
            ),
          ],
        );
      },
    );
  }
}
