import 'dart:io';
import 'package:bnan_app/core/helper/file_picker_helper.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/custom_file_picker_field.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/utils/payroll_file_validator.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class PayrollReceiptField extends StatelessWidget {
  const PayrollReceiptField({
    super.key,
    required this.path,
    required this.error,
    required this.onChanged,
  });
  final String? path, error;
  final ValueChanged<String?> onChanged;
  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomFilePickerField(
          label: s.payrollTransferReceipt,
          hint: path?.split(RegExp(r'[/\\]')).last ?? s.payrollChooseReceipt,
          hasFile: path != null,
          onTap: () => _pick(context),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(error!, style: const TextStyle(color: Colors.red)),
          ),
        if (path != null) ...[
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: path!.toLowerCase().endsWith('.pdf')
                ? Container(
                    height: 120,
                    width: double.infinity,
                    color: Colors.grey.shade100,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.picture_as_pdf,
                          size: 44,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          path!.split(RegExp(r'[/\\]')).last,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                : Image.file(
                    File(path!),
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),
          ),
          const SizedBox(height: 8),
          CustomAppButton(
            text: s.payrollRemoveReceipt,
            backgroundColor: Colors.white,
            textColor: Colors.red,
            onPressed: () => onChanged(null),
          ),
        ],
      ],
    );
  }

  Future<void> _pick(BuildContext context) async {
    final file = await FilePickerHelper.pickFile(
      allowedExtensions: const ['png', 'jpg', 'jpeg', 'webp', 'pdf'],
    );
    if (file == null) return;
    final code = await PayrollFileValidator.validate(file.path);
    if (!context.mounted) return;
    if (code != null) {
      onChanged('error:$code');
      return;
    }
    onChanged(file.path);
  }
}
