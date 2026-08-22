import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class AdminRenewalRejectDialog extends StatefulWidget {
  const AdminRenewalRejectDialog({super.key});
  @override
  State<AdminRenewalRejectDialog> createState() =>
      _AdminRenewalRejectDialogState();
}

class _AdminRenewalRejectDialogState extends State<AdminRenewalRejectDialog> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) => CustomAppDialog(
    width: 337,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomDialogHeader(title: S.of(context).rejectRequest),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _controller,
            label: S.of(context).renewalOptionalRejectionReason,
            maxLine: 5,
          ),
          const SizedBox(height: 16),
          CustomAppButton(
            text: S.of(context).reject,
            onPressed: () => Navigator.pop(context, _controller.text.trim()),
          ),
        ],
      ),
    ),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
