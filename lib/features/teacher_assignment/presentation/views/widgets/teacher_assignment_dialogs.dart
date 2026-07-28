import 'package:bnan_app/core/helper/app_dialogs.dart';
import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_assignment_submissions/get_assignment_submissions_cubit.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/review_assignment_submission/review_assignment_submission_cubit.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/views/widgets/correct_assignment/correct_assignment_dialog.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/views/widgets/create_assignment/create_assignment_dialog.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/views/widgets/submit_correction/submit_correction_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherAssignmentDialogs {
  const TeacherAssignmentDialogs._();

  static Future<bool?> showCreateAssignment(BuildContext context) {
    return AppDialogs.show<bool>(
      context: context,
      child: const CreateAssignmentDialog(),
    );
  }

  static Future<void> showCorrectAssignment(
    BuildContext context, {
    required String assignmentId,
    required String assignmentTitle,
    required num totalPoints,
  }) {
    return AppDialogs.show<void>(
      context: context,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            lazy: false,
            create: (_) =>
                getIt<GetAssignmentSubmissionsCubit>()
                  ..getAssignmentSubmissions(assignmentId: assignmentId),
          ),
          BlocProvider(create: (_) => getIt<ReviewAssignmentSubmissionCubit>()),
        ],
        child: CorrectAssignmentDialog(
          assignmentId: assignmentId,
          assignmentTitle: assignmentTitle,
          totalPoints: totalPoints,
        ),
      ),
    );
  }

  static Future<bool?> showSubmitCorrection(
    BuildContext context, {
    required String assignmentId,
    required String submissionId,
    required String studentName,
    required num totalPoints,
    required num? currentScore,
  }) {
    return AppDialogs.show<bool>(
      context: context,
      child: BlocProvider.value(
        value: context.read<ReviewAssignmentSubmissionCubit>(),
        child: SubmitCorrectionDialog(
          assignmentId: assignmentId,
          submissionId: submissionId,
          studentName: studentName,
          totalPoints: totalPoints,
          currentScore: currentScore,
        ),
      ),
    );
  }
}
