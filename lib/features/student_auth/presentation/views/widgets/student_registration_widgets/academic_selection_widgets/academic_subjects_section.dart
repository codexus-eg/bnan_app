import 'package:bnan_app/features/student_auth/presentation/manager/register_cubit/register_cubit.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/register_cubit/register_state.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/student_registration_widgets/student_info_step_widgets/subjects_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AcademicSubjectsSection extends StatelessWidget {
  const AcademicSubjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, _) {
        final cubit = RegisterCubit.get(context);
        if (!cubit.requiresSubjectSelection || cubit.selectedGradeId == null) {
          return const SizedBox.shrink();
        }
        return const Column(
          children: [
            SizedBox(height: 16),
            SubjectsList(),
          ],
        );
      },
    );
  }
}
