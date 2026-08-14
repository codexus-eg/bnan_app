import 'package:bnan_app/core/helper/validator_form_field.dart';
import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:flutter/material.dart';

class CustomPasswordField extends StatefulWidget {
  const CustomPasswordField({
    super.key,
    required this.label,
    this.controller,
    this.initialValue,
    this.hintText,
    this.onChanged,
  });

  final String label;
  final TextEditingController? controller;
  final String? initialValue, hintText;
  final ValueChanged<String>? onChanged;

  @override
  State<CustomPasswordField> createState() => _CustomPasswordFieldState();
}

class _CustomPasswordFieldState extends State<CustomPasswordField> {
  bool _obscured = true;

  @override
  Widget build(BuildContext context) => CustomTextField(
    controller: widget.controller,
    initialValue: widget.initialValue,
    label: widget.label,
    hintText: widget.hintText,
    isRequired: true,
    obscureText: _obscured,
    validator: MyValidator.validateRegistrationPassword,
    onChanged: widget.onChanged,
    suffixIcon: IconButton(
      onPressed: () => setState(() => _obscured = !_obscured),
      icon: Icon(
        _obscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
        color: ColorManager.greyA8AF,
      ),
    ),
  );
}
