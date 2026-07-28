import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_assignment_submissions/get_assignment_submissions_cubit.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_assignment_submissions/get_assignment_submissions_state.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'assignment_submissions_skeleton_data.dart';
import 'correction_submissions_content.dart';

class CorrectAssignmentBody extends StatelessWidget {
  const CorrectAssignmentBody({
    super.key,
    required this.assignmentId,
    required this.assignmentTitle,
    required this.totalPoints,
  });

  final String assignmentId;
  final String assignmentTitle;
  final num totalPoints;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomDialogHeader(title: S.of(context).correctAssignment),
            const SizedBox(height: 16),
            Text(
              assignmentTitle,
              style: StylesManager.styleRegular16(
                context,
              ).copyWith(color: ColorManager.greyA8AF),
            ),
            const SizedBox(height: 16),
            BlocBuilder<
              GetAssignmentSubmissionsCubit,
              GetAssignmentSubmissionsState
            >(
              builder: (context, state) {
                final isLoading =
                    state is GetAssignmentSubmissionsInitial ||
                    state is GetAssignmentSubmissionsLoading;
                final response = state is GetAssignmentSubmissionsSuccess
                    ? state.submissions
                    : null;
                final submissions =
                    response?.data ?? skeletonAssignmentSubmissions;

                if (state is GetAssignmentSubmissionsFailure) {
                  return const NoDataWidget();
                }

                if (!isLoading && submissions.isEmpty) {
                  return const NoDataWidget();
                }

                return AppSkeletonizer(
                  isLoading: isLoading,
                  child: CorrectionSubmissionsContent(
                    submissions: submissions,
                    assignmentId: assignmentId,
                    totalPoints: totalPoints,
                    totalStudents:
                        response?.summary.totalStudents ??
                        skeletonTotalStudents,
                    reviewed: response?.summary.reviewed ?? skeletonReviewed,
                    submitted: response?.summary.submitted ?? skeletonSubmitted,
                    notSubmitted:
                        response?.summary.notSubmitted ?? skeletonNotSubmitted,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
