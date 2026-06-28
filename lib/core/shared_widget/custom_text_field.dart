import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.label,
    this.hintText,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.isRequired = false,
    this.maxLine,
    this.readOnly = false,
    this.onTap,
    this.validator,
    this.backgroundColor,
    this.hintStyle,
    this.addLabel,
  });

  final String? label, addLabel;
  final String? hintText;
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
  final String? Function(String?)? validator;
  final Color? backgroundColor;

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
              Text(
                label!,
                style: StylesManager.styleBold14(
                  context,
                ).copyWith(color: ColorManager.mainColor15),
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
        SizedBox(
          height: isMultiLine ? null : 40,
          child: TextFormField(
            textInputAction: isMultiLine
                ? TextInputAction.newline
                : TextInputAction.done,
            validator: validator,
            readOnly: readOnly,
            onTap: onTap,
            maxLines: effectiveMaxLines,
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            decoration: InputDecoration(
              fillColor: backgroundColor,
              filled: backgroundColor != null ? true : false,
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
