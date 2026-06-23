import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/features/teacher_registration/presentation/manager/teacher_registration_cubit/teacher_registration_cubit.dart';
import 'package:bnan_app/features/teacher_registration/presentation/manager/teacher_registration_cubit/teacher_registration_state.dart';
import 'package:flutter/material.dart';

class TeacherRegistrationHandleNext {
  const TeacherRegistrationHandleNext._();

  static Future<void> call(
    BuildContext context,
    TeacherRegistrationState state,
  ) async {
    final cubit = TeacherRegistrationCubit.get(context);

    final error = _validateStep(cubit, state.currentStep);

    if (error != null) {
      if (error.isNotEmpty) {
        showCustomSnackBar(context, error, false);
      }
      return;
    }

    if (state.currentStep == TeacherRegistrationCubit.lastStep) {
      await cubit.registerTeacher();
      return;
    }

    cubit.nextStep();
  }

  static String? _validateStep(TeacherRegistrationCubit cubit, int step) {
    if (step == 1 && !cubit.validatePersonalInfoStep()) return '';
    if (step == 2 && !cubit.validateQualificationStep()) return '';
    if (step == 3) return cubit.validateExperienceStep();
    if (step == 4) return cubit.validateTeachingCurriculumStep();
    if (step == 5) return cubit.validateTeachingGradesSubjectsStep();
    if (step == 6) return cubit.validateTechnicalSkillsStep();
    if (step == 7) return cubit.validateEvaluationStep();
    if (step == 8) return cubit.validateAttachmentsStep();
    return null;
  }
}
