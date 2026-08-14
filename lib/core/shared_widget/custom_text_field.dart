import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.label,
    this.hintText,
    this.initialValue,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.isRequired = false,
    this.maxLine,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
    this.validator,
    this.backgroundColor,
    this.hintStyle,
    this.addLabel,
    this.labelColor,
    this.inputFormatters,
  });

  final String? label, addLabel;
  final String? hintText;
  final String? initialValue;
  final TextStyle? hintStyle;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool isRequired;
  final int? maxLine;
  final bool readOnly;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final Color? backgroundColor, labelColor;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    final effectiveMaxLines = obscureText ? 1 : (maxLine ?? 1);
    final isMultiLine = (effectiveMaxLines) > 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  label!,
                  style: StylesManager.styleBold14(
                    context,
                  ).copyWith(color: labelColor ?? ColorManager.mainColor15),
                ),
              ),
              if (isRequired)
                const Text(
                  '*',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              Text(
                addLabel ?? '',
                style: StylesManager.styleRegular14(
                  context,
                ).copyWith(color: ColorManager.greyA8AF),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: isMultiLine ? 0 : 40),
          child: TextFormField(
            initialValue: controller == null ? initialValue : null,
            onTap: onTap,
            textInputAction: isMultiLine
                ? TextInputAction.newline
                : TextInputAction.done,
            validator: validator,
            onChanged: onChanged,
            readOnly: readOnly,
            maxLines: effectiveMaxLines,
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            obscureText: obscureText,
            decoration: InputDecoration(
              fillColor: backgroundColor,
              filled: backgroundColor != null,
              hintText: hintText,
              hintStyle: hintStyle ?? StylesManager.styleLight12(context),
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              prefixIconConstraints: const BoxConstraints(minWidth: 16),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 13,
              ),
              border: _border(),
              enabledBorder: _border(),
              focusedBorder: _border(ColorManager.secondaryColor),
              errorBorder: _border(ColorManager.red),
              focusedErrorBorder: _border(ColorManager.red),
              disabledBorder: _border(),
              errorStyle: StylesManager.styleLight12(
                context,
              ).copyWith(color: ColorManager.red),
            ),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _border([Color color = ColorManager.borderColor]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: color),
    );
  }
}
