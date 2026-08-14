import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/data/models/student_assignment_model.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/presentation/manager/get_assignment/get_assignments_cubit.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/presentation/manager/submit_assignment/submit_assignment_cubit.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/presentation/manager/submit_assignment/submit_assignment_state.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/presentation/views/widgets/assignments/assignment_action_buttons.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssignmentCardActionsHandler extends StatelessWidget {
  const AssignmentCardActionsHandler({
    super.key,
    required this.assignment,
    required this.showSubmit,
    required this.isLoading,
  });

  final AssignmentModel assignment;
  final bool showSubmit;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SubmitAssignmentCubit, SubmitAssignmentState>(
      listener: (context, state) {
        if (state is SubmitAssignmentSuccess) {
          showCustomSnackBar(context, state.message, true);
          context.read<GetAssignmentsCubit>().getMyAssignments();
        }

        if (state is SubmitAssignmentFailure) {
          showCustomSnackBar(context, state.errorMessage, false);
        }
      },
      builder: (context, state) {
        final isSubmitting =
            state is SubmitAssignmentLoading &&
            state.assignmentId == assignment.id;

        return AssignmentActionButtons(
          showSubmit: showSubmit,
          isLoading: isLoading || isSubmitting,
          downloadUrl: assignment.attachment,
          downloadFileName: _attachmentName(assignment),
          onSubmit: () async {
            if (isLoading || isSubmitting) return;

            final result = await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
            );

            if (!context.mounted) return;
            final filePath = result?.files.single.path;
            if (filePath == null) {
              showCustomSnackBar(context, S.current.pleaseSelectFile, false);
              return;
            }

            context.read<SubmitAssignmentCubit>().submitAssignment(
              assignmentId: assignment.id,
              filePath: filePath,
            );
          },
        );
      },
    );
  }

  String _attachmentName(AssignmentModel value) {
    final segments = Uri.tryParse(value.attachment)?.pathSegments;
    return segments?.isNotEmpty == true
        ? segments!.last
        : '${value.title.trim().isEmpty ? 'assignment' : value.title}.pdf';
  }
}
