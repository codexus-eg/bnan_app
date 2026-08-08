import 'package:bnan_app/core/shared_widget/custom_dropdown_form_field.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class PayrollCurrencyField extends StatelessWidget {
  const PayrollCurrencyField({
    super.key,
    required this.value,
    required this.onChanged,
  });
  final String value;
  final ValueChanged<String?> onChanged;
  static const values = ['EGP', 'SAR', 'AED', 'KWD', 'QAR', 'BHD', 'OMR'];
  @override
  Widget build(BuildContext context) => CustomDropdownFormField(
    label: S.of(context).currency,
    value: value,
    items: values,
    onChanged: onChanged,
    isRequired: true,
  );
}
