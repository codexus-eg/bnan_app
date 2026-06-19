import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/presentation/views/widgets/assignments/assignment_action_button.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class AssignmentActionButtons extends StatelessWidget {
  const AssignmentActionButtons({
    super.key,
    required this.showSubmit,
    required this.onDownload,
    required this.onSubmit,
    required this.isLoading,
  });

  final bool showSubmit;
  final VoidCallback onDownload;
  final VoidCallback onSubmit;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AssignmentActionButton(
            text: S.of(context).download,
            icon: ImageManager.downloadIcon,
            onTap: isLoading ? null : onDownload,
          ),
        ),
        if (showSubmit) ...[
          const SizedBox(width: 21),
          Expanded(
            child: AssignmentActionButton(
              text: S.of(context).submitAssignment,
              icon: ImageManager.upload,
              isFilled: true,
              onTap: isLoading ? null : onSubmit,
            ),
          ),
        ],
      ],
    );
  }
}
