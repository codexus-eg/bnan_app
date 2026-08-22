import 'package:bnan_app/features/teacher_registration/presentation/manager/teacher_registration_cubit/teacher_registration_cubit.dart';
import 'package:bnan_app/features/teacher_registration/presentation/manager/teacher_registration_cubit/teacher_registration_state.dart';
import 'package:bnan_app/features/teacher_registration/presentation/views/widgets/teacher_shared_widgets/teacher_yes_no_question/teacher_answer_button.dart';
import 'package:bnan_app/features/teacher_registration/presentation/views/widgets/teacher_shared_widgets/teacher_yes_no_question/teacher_question_title.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherTechnicalAppsLevel extends StatelessWidget {
  const TeacherTechnicalAppsLevel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeacherRegistrationCubit, TeacherRegistrationState>(
      builder: (context, state) {
        final cubit = TeacherRegistrationCubit.get(context);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TeacherQuestionTitle(
              question: S.of(context).technicalAppsLevel,
              isRequired: true,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                TeacherAnswerButton(
                  text: S.of(context).excellent,
                  isSelected: cubit.computerUsageLevel == 'excellent',
                  onTap: () => cubit.changeComputerUsageLevel('excellent'),
                ),
                const SizedBox(width: 16),
                TeacherAnswerButton(
                  text: S.of(context).veryGood,
                  isSelected: cubit.computerUsageLevel == 'very-good',
                  onTap: () => cubit.changeComputerUsageLevel('very-good'),
                ),
                const SizedBox(width: 16),
                TeacherAnswerButton(
                  text: S.of(context).good,
                  isSelected: cubit.computerUsageLevel == 'good',
                  onTap: () => cubit.changeComputerUsageLevel('good'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
