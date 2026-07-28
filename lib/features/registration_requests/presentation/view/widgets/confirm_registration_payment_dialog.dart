import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/core/shared_widget/custom_file_picker_field.dart';
import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

const registrationPaymentMethods = [
  'cash',
  'bank_transfer',
  'instapay',
  'wallet',
  'other',
];

class ConfirmRegistrationPaymentDialog extends StatefulWidget {
  const ConfirmRegistrationPaymentDialog({super.key});

  @override
  State<ConfirmRegistrationPaymentDialog> createState() =>
      _ConfirmRegistrationPaymentDialogState();
}

class _ConfirmRegistrationPaymentDialogState
    extends State<ConfirmRegistrationPaymentDialog> {
  final amountController = TextEditingController();
  final notesController = TextEditingController();
  String selectedPaymentMethod = 'cash';

  @override
  void dispose() {
    amountController.dispose();
    notesController.dispose();
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomDialogHeader(title: s.confirmRequest),
            const SizedBox(height: 16),
            CustomTextField(
              controller: amountController,
              label: s.paidAmount,
              hintText: s.paidAmountHint,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            const SizedBox(height: 16),
            CustomDropdown(
              label: s.paymentMethods,
              items: registrationPaymentMethods,
              value: selectedPaymentMethod,
              itemsLabels: {
                'cash': s.cash,
                'bank_transfer': s.bankTransfer,
                'instapay': s.instapay,
                'wallet': s.wallet,
                'other': s.other,
              },
              onChanged: (value) {
                if (value != null) {
                  setState(() => selectedPaymentMethod = value);
                }
              },
            ),
            const SizedBox(height: 16),
            CustomFilePickerField(
              label: s.paymentReceipt,
              hint: s.uploadPaymentReceipt,
              onTap: () {},
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: notesController,
              label: s.notesText,
              maxLine: 4,
              keyboardType: TextInputType.multiline,
            ),
            const SizedBox(height: 16),
            CustomAppButton(text: s.confirm, onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
