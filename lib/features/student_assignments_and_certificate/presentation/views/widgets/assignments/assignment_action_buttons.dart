import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/shared_widget/download_icon_button.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/presentation/views/widgets/assignments/assignment_action_button.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class AssignmentActionButtons extends StatelessWidget {
  const AssignmentActionButtons({
    super.key,
    required this.showSubmit,
    required this.downloadUrl,
    required this.downloadFileName,
    required this.onSubmit,
    required this.isLoading,
  });

  final bool showSubmit;
  final String downloadUrl;
  final String downloadFileName;
  final VoidCallback onSubmit;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DownloadIconButton(
          url: downloadUrl,
          fileName: downloadFileName,
          enabled: !isLoading,
        ),
        if (showSubmit) ...[
          const SizedBox(width: 21),
          Expanded(
            child: AssignmentActionButton(
              text: isLoading
                  ? S.of(context).submittingAssignment
                  : S.of(context).submitAssignment,
              icon: ImageManager.upload,
              isFilled: true,
              isLoading: isLoading,
              onTap: isLoading ? null : onSubmit,
            ),
          ),
        ],
      ],
    );
  }
}
