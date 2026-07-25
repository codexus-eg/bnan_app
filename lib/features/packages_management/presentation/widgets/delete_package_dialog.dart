import 'package:bnan_app/core/shared_widget/dialogs/custom_delete_dialog.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class DeletePackageDialog extends StatelessWidget {
  const DeletePackageDialog({
    super.key,
    required this.packageId,
    required this.isLoading,
    this.onPressed,
  });

  final String packageId;
  final bool isLoading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return CustomDeleteDialog(
      gradeId: packageId,
      isLoading: isLoading,
      dialogHeader: S.of(context).deletePackage,
      subtitle: S.of(context).deletePackageConfirmation,
      onPressed: onPressed,
    );
  }
}