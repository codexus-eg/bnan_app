import 'package:bnan_app/features/teacher_registration/presentation/manager/teacher_registration_cubit/teacher_registration_cubit.dart';
import 'package:bnan_app/features/teacher_registration/presentation/manager/teacher_registration_cubit/teacher_registration_state.dart';
import 'package:bnan_app/features/teacher_registration/presentation/views/widgets/teacher_shared_widgets/teacher_yes_no_question/teacher_yes_no_question.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherTechnicalQuestions extends StatelessWidget {
  const TeacherTechnicalQuestions({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeacherRegistrationCubit, TeacherRegistrationState>(
      builder: (context, state) {
        final cubit = TeacherRegistrationCubit.get(context);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TeacherYesNoQuestion(
              question: S.of(context).hasLaptopOrComputer,
              value: cubit.hasLaptopOrComputer,
              onChanged: cubit.changeHasLaptopOrComputer,
            ),
            const SizedBox(height: 16),
            TeacherYesNoQuestion(
              question: S.of(context).hasStableInternet,
              value: cubit.hasStableInternet,
              onChanged: cubit.changeHasStableInternet,
            ),
            const SizedBox(height: 16),
            TeacherYesNoQuestion(
              question: S.of(context).hasGoodCamera,
              value: cubit.hasGoodCamera,
              onChanged: cubit.changeHasGoodCamera,
            ),
            const SizedBox(height: 16),
            TeacherYesNoQuestion(
              question: S.of(context).hasClearMic,
              value: cubit.hasClearMic,
              onChanged: cubit.changeHasClearMic,
            ),
          ],
        );
      },
    );
  }
}