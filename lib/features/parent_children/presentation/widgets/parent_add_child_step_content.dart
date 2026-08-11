import 'package:bnan_app/features/parent_children/presentation/widgets/child_account_step.dart';
import 'package:bnan_app/features/parent_children/presentation/widgets/parent_grade_step.dart';
import 'package:bnan_app/features/parent_children/presentation/widgets/parent_package_step.dart';
import 'package:bnan_app/features/parent_children/presentation/widgets/parent_payment_step.dart';
import 'package:bnan_app/features/parent_children/presentation/widgets/parent_price_review_step.dart';
import 'package:bnan_app/features/parent_children/presentation/widgets/parent_subjects_step.dart';
import 'package:flutter/material.dart';

class ParentAddChildStepContent extends StatelessWidget {
  const ParentAddChildStepContent({super.key, required this.step});

  final int step;

  @override
  Widget build(BuildContext context) => switch (step) {
    0 => const ChildAccountStep(),
    1 => const ParentGradeStep(),
    2 => const ParentPackageStep(),
    3 => const ParentSubjectsStep(),
    4 => const ParentPriceReviewStep(),
    _ => const ParentPaymentStep(),
  };
}
