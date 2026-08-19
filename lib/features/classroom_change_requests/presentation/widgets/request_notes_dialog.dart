import 'package:bnan_app/core/helper/validator_form_field.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class RequestNotesDialog extends StatefulWidget {
  const RequestNotesDialog({
    super.key,
    required this.title,
    required this.label,
    this.required = true,
  });
  final String title, label;
  final bool required;

  @override
  State<RequestNotesDialog> createState() => _RequestNotesDialogState();
}

class _RequestNotesDialogState extends State<RequestNotesDialog> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => CustomAppDialog(
    width: 337,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomDialogHeader(title: widget.title),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _controller,
              label: widget.label,
              maxLine: 5,
              validator: widget.required
                  ? (value) => MyValidator.requiredField(value, widget.label)
                  : null,
            ),
            const SizedBox(height: 16),
            CustomAppButton(text: S.of(context).confirm, onPressed: _submit),
          ],
        ),
      ),
    ),
  );

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    Navigator.pop(context, _controller.text.trim());
  }
}
