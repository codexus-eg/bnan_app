import 'dart:io';
import 'package:bnan_app/core/helper/file_picker_helper.dart';
import 'package:bnan_app/core/shared_widget/custom_file_picker_field.dart';
import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ParentEgyptianPaymentFields extends StatelessWidget {
  const ParentEgyptianPaymentFields({
    super.key,
    required this.receipt,
    required this.onReceiptChanged,
    required this.onMethodChanged,
    required this.onReferenceChanged,
  });
  final File? receipt;
  final ValueChanged<File> onReceiptChanged;
  final ValueChanged<String> onMethodChanged, onReferenceChanged;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Column(
      children: [
        CustomTextField(
          label: s.parentPaymentMethodOptional,
          onChanged: onMethodChanged,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: s.parentReferenceNumberOptional,
          onChanged: onReferenceChanged,
        ),
        const SizedBox(height: 16),
        CustomFilePickerField(
          label: s.paymentReceipt,
          hint: receipt == null
              ? s.uploadPaymentReceipt
              : s.parentReceiptSelected,
          hasFile: receipt != null,
          onTap: () async {
            final file = await FilePickerHelper.pickFile(
              allowedExtensions: const ['jpg', 'jpeg', 'png'],
            );
            if (file != null) onReceiptChanged(file);
          },
        ),
      ],
    );
  }
}
