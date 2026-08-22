import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class CustomDeleteDialog extends StatelessWidget {
  const CustomDeleteDialog({
    super.key,
    required this.gradeId,
    required this.isLoading,
    required this.dialogHeader,
    required this.subtitle,
    this.onPressed,
    this.showCancelButton = false,
  });

  final String gradeId;
  final bool isLoading;
  final bool showCancelButton;
  final String dialogHeader, subtitle;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomDialogHeader(title: dialogHeader),
          const SizedBox(height: 16),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: StylesManager.styleBold14(
              context,
            ).copyWith(color: ColorManager.mainColor14),
          ),
          const SizedBox(height: 16),
          if (showCancelButton)
            Row(
              children: [
                Expanded(
                  child: CustomAppButton(
                    text: S.of(context).cancel,
                    onPressed: isLoading ? null : () => Navigator.pop(context),
                    backgroundColor: ColorManager.white,
                    borderColor: ColorManager.blueE3,
                    textColor: ColorManager.mainColor15,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(child: _deleteButton(context)),
              ],
            )
          else
            _deleteButton(context),
        ],
      ),
    );
  }

  Widget _deleteButton(BuildContext context) => CustomAppButton(
    text: S.of(context).delete,
    backgroundColor: ColorManager.redBA,
    isLoading: isLoading,
    onPressed: onPressed,
  );
}
