import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  const CustomDropdown({
    super.key,
    required this.label,
    this.items,
    this.itemsLabels,
    required this.onChanged,
    this.value,
    this.hint,
    this.isRequired = false,
    this.hintStyle,
    this.backgroundColor,
    this.labelColor,
    this.valueStyle,
    this.showLabel = true,
    this.fieldHeight = 40,
    this.useDefaultIcon = false,
    this.isDense = false,
  });

  final String label;
  final String? value;
  final TextStyle? hintStyle, valueStyle;
  final String? hint;
  final List<String>? items;
  final Map<String, String>? itemsLabels;
  final ValueChanged<String?>? onChanged;
  final bool isRequired, showLabel, useDefaultIcon, isDense;
  final double fieldHeight;
  final Color? backgroundColor, labelColor;

  String _labelOf(String item) => itemsLabels?[item] ?? item;

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = items == null || items!.isEmpty;
    final List<String> dropdownItems = items ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel) ...[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: StylesManager.styleBold14(
                  context,
                ).copyWith(color: labelColor ?? ColorManager.mainColor15),
              ),
              if (isRequired)
                const Text('*', style: TextStyle(color: Colors.red)),
            ],
          ),
          const SizedBox(height: 8),
        ],
        Container(
          constraints: BoxConstraints(minHeight: fieldHeight),
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
              isDense: isDense,
              icon: useDefaultIcon
                  ? const Icon(
                      Icons.keyboard_arrow_down,
                      color: ColorManager.greyA8AF,
                      size: 22,
                    )
                  : const SizedBox.shrink(),
              hint: _DropdownDisplayedText(
                text: hint ?? '',
                isDisabled: isDisabled,
                hintStyle: hintStyle,
                showLeadingIcon: !useDefaultIcon,
              ),
              selectedItemBuilder: (context) {
                return dropdownItems.map((item) {
                  return _DropdownDisplayedText(
                    text: _labelOf(item),
                    isDisabled: isDisabled,
                    valueStyle: valueStyle,
                    showLeadingIcon: !useDefaultIcon,
                  );
                }).toList();
              },
              items: dropdownItems.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    _labelOf(item),
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
    this.valueStyle,
    this.showLeadingIcon = true,
  });

  final String text;
  final bool isDisabled;
  final TextStyle? hintStyle;
  final TextStyle? valueStyle;
  final bool showLeadingIcon;

  @override
  Widget build(BuildContext context) {
    final color = isDisabled ? ColorManager.greyA8AF : ColorManager.mainColor15;

    return Row(
      children: [
        if (showLeadingIcon) ...[
          Icon(
            Icons.keyboard_arrow_down,
            color: ColorManager.greyA8AF,
            size: 22,
          ),
          const SizedBox(width: 8),
        ],
        Expanded(
          child: Text(
            text,
            textAlign: TextAlign.start,
            style:
                valueStyle ??
                hintStyle ??
                StylesManager.styleRegular16(context).copyWith(color: color),
          ),
        ),
      ],
    );
  }
}
