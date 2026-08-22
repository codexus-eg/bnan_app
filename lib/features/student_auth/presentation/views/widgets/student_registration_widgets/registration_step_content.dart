import 'package:bnan_app/features/student_auth/presentation/views/widgets/student_registration_widgets/curriculm_selection_widgets/curriculum_selection_step.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/student_registration_widgets/parent_info_step_widgets/parent_info_step.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/student_registration_widgets/payment_method_step.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/student_registration_widgets/student_info_step_widgets/student_info_step.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/student_registration_widgets/registration_review_step.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/register_cubit/register_cubit.dart';
import 'package:flutter/material.dart';

class RegistrationStepContent extends StatelessWidget {
  const RegistrationStepContent({super.key, required this.currentStep});

  final int currentStep;

  @override
  Widget build(BuildContext context) {
    switch (currentStep) {
      case 1:
        return const ParentInfoStep();
      case 2:
        return const CurriculumSelectionStep();
      case 3:
        return const StudentInfoStep();
      case 4:
        return RegisterCubit.get(context).isGulf
            ? const PaymentMethodStep()
            : const RegistrationReviewStep();
      default:
        return const ParentInfoStep();
    }
  }
}
