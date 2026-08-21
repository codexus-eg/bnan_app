import 'package:bnan_app/core/helper/validator_form_field.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
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
    this.requestTypes,
    this.onSubmit,
  });
  final String title, label;
  final bool required;
  final List<String>? requestTypes;
  final Future<bool> Function(RequestNotesResult result)? onSubmit;

  @override
  State<RequestNotesDialog> createState() => _RequestNotesDialogState();
}

class _RequestNotesDialogState extends State<RequestNotesDialog> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  String? _requestType;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    final requestTypes = widget.requestTypes;
    _requestType = requestTypes?.isNotEmpty == true
        ? requestTypes!.first
        : null;
  }

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
            if (widget.requestTypes != null) ...[
              CustomDropdown(
                label: S.of(context).requestType,
                value: _requestType,
                items: widget.requestTypes,
                itemsLabels: {
                  'change_teacher': S.of(context).changeTeacherRequestType,
                  'cancel_subject': S.of(context).cancelSubjectRequestType,
                },
                onChanged: (value) => setState(() => _requestType = value),
              ),
              const SizedBox(height: 16),
            ],
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

  Future<void> _submit() async {
    if (_submitting || !(_formKey.currentState?.validate() ?? false)) return;
    final result = RequestNotesResult(
      notes: _controller.text.trim(),
      requestType: _requestType,
    );
    final onSubmit = widget.onSubmit;
    if (onSubmit == null) {
      Navigator.pop<RequestNotesResult>(context, result);
      return;
    }
    _submitting = true;
    final accepted = await onSubmit(result);
    if (!mounted) return;
    _submitting = false;
    if (accepted) Navigator.pop<RequestNotesResult>(context, result);
  }
}

class RequestNotesResult {
  const RequestNotesResult({required this.notes, this.requestType});
  final String notes;
  final String? requestType;
}
