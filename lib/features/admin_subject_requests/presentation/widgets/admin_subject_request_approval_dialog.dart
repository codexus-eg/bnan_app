import 'dart:io';

import 'package:bnan_app/core/helper/file_picker_helper.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/core/shared_widget/custom_file_picker_field.dart';
import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/admin_subject_requests/data/models/admin_subject_request_approval.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class AdminSubjectRequestApprovalDialog extends StatefulWidget {
  const AdminSubjectRequestApprovalDialog({super.key});
  @override
  State<AdminSubjectRequestApprovalDialog> createState() =>
      _AdminSubjectRequestApprovalDialogState();
}

class _AdminSubjectRequestApprovalDialogState
    extends State<AdminSubjectRequestApprovalDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amount = TextEditingController();
  final _reference = TextEditingController();
  final _notes = TextEditingController();
  String? _method;
  File? _receipt;
  bool _receiptMissing = false;

  @override
  void dispose() {
    _amount.dispose();
    _reference.dispose();
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return CustomAppDialog(
      width: 337,
      child: SingleChildScrollView(
        padding: EdgeInsetsDirectional.fromSTEB(
          16,
          16,
          16,
          16 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomDialogHeader(title: s.adminSubjectRequestApprove),
              const SizedBox(height: 16),
              CustomFilePickerField(
                label: s.paymentReceipt,
                hint: _receipt == null
                    ? s.uploadPaymentReceipt
                    : _receipt!.path.split(Platform.pathSeparator).last,
                hasFile: _receipt != null,
                onTap: _pickReceipt,
              ),
              if (_receiptMissing) _error(s.paymentReceiptRequired),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _amount,
                label: s.adminSubjectRequestAmountOptional,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.isEmpty) return null;
                  final number = num.tryParse(text);
                  return number == null || number <= 0
                      ? s.invalidPaymentAmount
                      : null;
                },
              ),
              const SizedBox(height: 16),
              CustomDropdown(
                label: s.adminSubjectRequestMethodOptional,
                items: AdminSubjectRequestApproval.allowedMethods.toList(),
                value: _method,
                itemsLabels: {
                  'cash': s.cash,
                  'bank_transfer': s.bankTransfer,
                  'instapay': s.instapay,
                  'wallet': s.wallet,
                  'other': s.other,
                },
                onChanged: (value) => setState(() => _method = value),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _reference,
                label: s.adminSubjectRequestReferenceNumber,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _notes,
                label: s.adminSubjectRequestPaymentNotes,
                maxLine: 4,
              ),
              const SizedBox(height: 16),
              CustomAppButton(text: s.confirm, onPressed: _submit),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickReceipt() async {
    final file = await FilePickerHelper.pickFile(
      allowedExtensions: const ['jpg', 'jpeg', 'png'],
    );
    if (file != null && mounted) {
      setState(() {
        _receipt = file;
        _receiptMissing = false;
      });
    }
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_receipt == null) {
      setState(() => _receiptMissing = true);
      return;
    }
    Navigator.of(context).pop(
      AdminSubjectRequestApproval(
        receiptImagePath: _receipt!.path,
        amount: num.tryParse(_amount.text.trim()),
        method: _method,
        referenceNumber: _reference.text,
        paymentNotes: _notes.text,
      ),
    );
  }

  Widget _error(String message) => Align(
    alignment: AlignmentDirectional.centerStart,
    child: Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Text(
        message,
        style: StylesManager.styleLight12(
          context,
        ).copyWith(color: ColorManager.red),
      ),
    ),
  );
}
