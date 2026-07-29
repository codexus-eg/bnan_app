import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/core/shared_widget/custom_file_picker_field.dart';
import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

const registrationPaymentMethods = [
  'cash',
  'bank_transfer',
  'instapay',
  'wallet',
  'other',
];

class RegistrationPaymentDialogContent extends StatelessWidget {
  const RegistrationPaymentDialogContent({
    super.key,
    required this.formKey,
    required this.amountController,
    required this.notesController,
    required this.paymentMethod,
    required this.isLoading,
    required this.onPaymentMethodChanged,
    this.receiptName,
    this.receiptError,
    this.submissionError,
    this.onPickReceipt,
    this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController amountController;
  final TextEditingController notesController;
  final String paymentMethod;
  final String? receiptName;
  final String? receiptError;
  final String? submissionError;
  final bool isLoading;
  final ValueChanged<String?> onPaymentMethodChanged;
  final VoidCallback? onPickReceipt;
  final VoidCallback? onSubmit;

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
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomDialogHeader(title: s.confirmRequest),
              const SizedBox(height: 16),
              _AmountField(controller: amountController),
              const SizedBox(height: 16),
              _PaymentMethodField(
                value: paymentMethod,
                onChanged: onPaymentMethodChanged,
              ),
              const SizedBox(height: 16),
              CustomFilePickerField(
                label: s.paymentReceipt,
                hint: receiptName ?? s.uploadPaymentReceipt,
                hasFile: receiptName != null,
                onTap: onPickReceipt,
              ),
              if (receiptError != null) _ErrorText(receiptError!),
              const SizedBox(height: 16),
              CustomTextField(
                controller: notesController,
                label: s.notesText,
                maxLine: 4,
                keyboardType: TextInputType.multiline,
              ),
              if (submissionError != null) _ErrorText(submissionError!),
              const SizedBox(height: 16),
              CustomAppButton(
                text: s.confirm,
                isLoading: isLoading,
                onPressed: onSubmit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AmountField extends StatelessWidget {
  const _AmountField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return CustomTextField(
      controller: controller,
      label: s.paidAmount,
      hintText: s.paidAmountHint,
      isRequired: true,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      validator: (value) {
        final amount = num.tryParse(value?.trim() ?? '');
        return amount == null || amount < 0.01 ? s.invalidPaymentAmount : null;
      },
    );
  }
}

class _PaymentMethodField extends StatelessWidget {
  const _PaymentMethodField({required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return CustomDropdown(
      label: s.paymentMethods,
      isRequired: true,
      items: registrationPaymentMethods,
      value: value,
      itemsLabels: {
        'cash': s.cash,
        'bank_transfer': s.bankTransfer,
        'instapay': s.instapay,
        'wallet': s.wallet,
        'other': s.other,
      },
      onChanged: onChanged,
    );
  }
}

class _ErrorText extends StatelessWidget {
  const _ErrorText(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Align(
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
}
