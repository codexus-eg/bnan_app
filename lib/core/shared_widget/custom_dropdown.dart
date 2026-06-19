import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  const CustomDropdown({
    super.key,
    required this.label,
    this.items,
    required this.onChanged,
    this.value,
    this.hint,
    this.isRequired = false,
    this.hintStyle,
    this.backgroundColor,
  });

  final String label;
  final String? value;
  final TextStyle? hintStyle;
  final String? hint;
  final List<String>? items;
  final ValueChanged<String?> onChanged;
  final bool isRequired;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = items == null || items!.isEmpty;
    final List<String> dropdownItems = items ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: StylesManager.styleBold14(
                context,
              ).copyWith(color: ColorManager.mainColor15),
            ),
            if (isRequired)
              const Text('*', style: TextStyle(color: Colors.red)),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: isDisabled
                ? ColorManager.greyF4F6
                : backgroundColor ?? Colors.transparent,
            border: Border.all(color: ColorManager.borderColor),
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: dropdownItems.contains(value) ? value : null,
              isExpanded: true,
              icon: const SizedBox.shrink(),
              hint: _DropdownDisplayedText(
                text: hint ?? '',
                isDisabled: isDisabled,
                hintStyle: hintStyle,
              ),
              selectedItemBuilder: (context) {
                return dropdownItems.map((item) {
                  return _DropdownDisplayedText(
                    text: item,
                    isDisabled: isDisabled,
                  );
                }).toList();
              },
              items: dropdownItems.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: StylesManager.styleRegular16(
                      context,
                    ).copyWith(color: ColorManager.mainColor15),
                  ),
                );
              }).toList(),
              onChanged: isDisabled ? null : onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

class _DropdownDisplayedText extends StatelessWidget {
  const _DropdownDisplayedText({
    required this.text,
    required this.isDisabled,
    this.hintStyle,
  });

  final String text;
  final bool isDisabled;
  final TextStyle? hintStyle;

  @override
  Widget build(BuildContext context) {
    final color = isDisabled ? ColorManager.greyA8AF : ColorManager.mainColor15;

    return Row(
      children: [
        Icon(
          Icons.keyboard_arrow_down,
          color: isDisabled ? ColorManager.greyA8AF : ColorManager.greyA8AF,
          size: 22,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            textAlign: TextAlign.start,
            style:
                hintStyle ??
                StylesManager.styleRegular16(context).copyWith(color: color),
          ),
        ),
      ],
    );
  }
}
