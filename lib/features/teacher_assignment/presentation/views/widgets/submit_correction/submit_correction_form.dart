import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/review_assignment_submission/review_assignment_submission_cubit.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/review_assignment_submission/review_assignment_submission_state.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'submit_correction_grade_field.dart';

class SubmitCorrectionForm extends StatefulWidget {
  const SubmitCorrectionForm({
    super.key,
    required this.assignmentId,
    required this.submissionId,
    required this.studentName,
    required this.totalPoints,
    required this.currentScore,
    required this.isLoading,
  });

  final String assignmentId;
  final String submissionId;
  final String studentName;
  final num totalPoints;
  final num? currentScore;
  final bool isLoading;

  @override
  State<SubmitCorrectionForm> createState() => _SubmitCorrectionFormState();
}

class _SubmitCorrectionFormState extends State<SubmitCorrectionForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _gradeController;

  @override
  void initState() {
    super.initState();
    _gradeController = TextEditingController(
      text: widget.currentScore == null
          ? null
          : formatScoreNumber(widget.currentScore!),
    );
  }

  @override
  void dispose() {
    _gradeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomDialogHeader(
              title: S.of(context).submitAssignmentCorrection,
              style: StylesManager.styleRegular16(
                context,
              ).copyWith(color: ColorManager.greyA8AF),
            ),
            const SizedBox(height: 16),
            Text(
              widget.studentName,
              style: StylesManager.styleBold16(
                context,
              ).copyWith(color: ColorManager.mainColor14),
            ),
            const SizedBox(height: 16),
            SubmitCorrectionGradeField(
              controller: _gradeController,
              totalPoints: widget.totalPoints,
              readOnly: widget.isLoading,
            ),
            const SizedBox(height: 16),
            CustomAppButton(
              text: S.of(context).sendCorrection,
              isLoading: widget.isLoading,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    final cubit = context.read<ReviewAssignmentSubmissionCubit>();
    final state = cubit.state;
    if (state is ReviewAssignmentSubmissionLoading &&
        state.submissionId == widget.submissionId) {
      return;
    }
    if (_formKey.currentState?.validate() != true) return;
    final score = int.parse(_gradeController.text.trim());
    cubit.reviewSubmission(
      assignmentId: widget.assignmentId,
      submissionId: widget.submissionId,
      score: score,
    );
  }
}
