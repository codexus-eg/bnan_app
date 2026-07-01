import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class CustomDropdownFormField extends StatelessWidget {
  const CustomDropdownFormField({
    super.key,
    required this.label,
    required this.items,
    required this.onChanged,
    this.value,
    this.hint,
    this.isRequired = false,
    this.validator,
    this.backgroundColor, this.labelColor, this.hintStyle,
  });

  final String label;
  final String? value;
  final String? hint;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final bool isRequired;
  final String? Function(String?)? validator;
  final Color? backgroundColor,labelColor;
  final TextStyle? hintStyle;

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: value,
      validator: validator,
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomDropdown(
              hintStyle: hintStyle,
              backgroundColor: backgroundColor,
              label: label,
              value: field.value,
              hint: hint,
              labelColor: labelColor,
              items: items,
              isRequired: isRequired,
              onChanged: (newValue) {
                field.didChange(newValue);
                onChanged(newValue);
              },
            ),
            if (field.hasError) ...[
              const SizedBox(height: 6),
              Text(
                field.errorText ?? '',
                style: StylesManager.styleRegular12(
                  context,
                ).copyWith(color: Colors.red),
              ),
            ],
          ],
        );
      },
    );
  }
}
