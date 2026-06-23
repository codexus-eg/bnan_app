import 'package:bnan_app/features/teacher_registration/presentation/manager/teacher_registration_cubit/teacher_registration_cubit.dart';
import 'package:bnan_app/features/teacher_registration/presentation/manager/teacher_registration_cubit/teacher_registration_state.dart';
import 'package:bnan_app/features/teacher_registration/presentation/views/widgets/teacher_shared_widgets/teacher_yes_no_question/teacher_yes_no_question.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherTrialLessonQuestion extends StatelessWidget {
  const TeacherTrialLessonQuestion({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeacherRegistrationCubit, TeacherRegistrationState>(
      builder: (context, state) {
        final cubit = TeacherRegistrationCubit.get(context);

        return TeacherYesNoQuestion(
          question: S.of(context).canProvideTrialLesson,
          value: cubit.canProvideTrialLesson,
          onChanged: cubit.changeCanProvideTrialLesson,
        );
      },
    );
  }
}