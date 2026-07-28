import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/review_assignment_submission/review_assignment_submission_cubit.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/review_assignment_submission/review_assignment_submission_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'submit_correction_form.dart';

class SubmitCorrectionDialog extends StatelessWidget {
  const SubmitCorrectionDialog({
    super.key,
    required this.assignmentId,
    required this.submissionId,
    required this.studentName,
    required this.totalPoints,
    required this.currentScore,
  });

  final String assignmentId;
  final String submissionId;
  final String studentName;
  final num totalPoints;
  final num? currentScore;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<
      ReviewAssignmentSubmissionCubit,
      ReviewAssignmentSubmissionState
    >(
      listener: _listen,
      builder: (context, state) {
        final isLoading =
            state is ReviewAssignmentSubmissionLoading &&
            state.submissionId == submissionId;
        return PopScope(
          canPop: !isLoading,
          child: CustomAppDialog(
            child: SubmitCorrectionForm(
              assignmentId: assignmentId,
              submissionId: submissionId,
              studentName: studentName,
              totalPoints: totalPoints,
              currentScore: currentScore,
              isLoading: isLoading,
            ),
          ),
        );
      },
    );
  }

  void _listen(BuildContext context, ReviewAssignmentSubmissionState state) {
    if (state is ReviewAssignmentSubmissionSuccess &&
        state.submissionId == submissionId) {
      Navigator.of(context).pop(true);
    } else if (state is ReviewAssignmentSubmissionFailure &&
        state.submissionId == submissionId) {
      showCustomSnackBar(context, state.errorMessage, false);
    }
  }
}
