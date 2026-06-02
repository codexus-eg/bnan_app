import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/features/assignments_and_certificate/presentation/views/widgets/assignments/assignment_action_button.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class AssignmentActionButtons extends StatelessWidget {
  const AssignmentActionButtons({
    super.key,
    required this.showSubmit,
    required this.onDownload,
    required this.onSubmit,
  });

  final bool showSubmit;
  final VoidCallback onDownload;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AssignmentActionButton(
            text: S.of(context).download,
            icon: ImageManager.downloadIcon,
            onTap: onDownload,
          ),
        ),
        if (showSubmit) ...[
          const SizedBox(width: 21),
          Expanded(
            child: AssignmentActionButton(
              text: S.of(context).submitAssignment,
              icon:ImageManager.upload,
              isFilled: true,
              onTap: onSubmit,
            ),
          ),
        ],
      ],
    );
  }
}