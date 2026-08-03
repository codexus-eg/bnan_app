import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class DeleteAssignmentDialogActions extends StatelessWidget {
  const DeleteAssignmentDialogActions({
    super.key,
    required this.loading,
    required this.onConfirm,
  });

  final bool loading;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomAppButton(
            text: S.of(context).yes,
            height: 40,
            isLoading: loading,
            onPressed: loading ? null : onConfirm,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: CustomAppButton(
            text: S.of(context).no,
            height: 40,
            onPressed: () => Navigator.pop(context),
            backgroundColor: ColorManager.white,
            borderColor: ColorManager.blueE3,
            textColor: ColorManager.mainColor15,
          ),
        ),
      ],
    );
  }
}
