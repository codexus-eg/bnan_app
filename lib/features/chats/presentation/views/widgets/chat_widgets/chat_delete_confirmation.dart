import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_delete_dialog.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

Future<bool> showChatDeleteConfirmation(
  BuildContext context,
  int messageCount,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => CustomAppDialog(
      child: CustomDeleteDialog(
        gradeId: '',
        isLoading: false,
        showCancelButton: true,
        dialogHeader: S.of(context).delete,
        subtitle: messageCount == 1
            ? S.of(context).deleteMessageQuestion
            : S.of(context).deleteSelectedMessagesQuestion,
        onPressed: () => Navigator.pop(dialogContext, true),
      ),
    ),
  );
  return confirmed == true;
}
