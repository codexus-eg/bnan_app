import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class CustomAuthDropdown extends StatelessWidget {
  const CustomAuthDropdown({
    super.key,
    required this.label,
    required this.items,
    required this.onChanged,
    this.value,
    this.hint,
    this.isRequired = false,
  });

  final String label;
  final String? value;
  final String? hint;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: StylesManager.styleBold14(context).copyWith(
                color: ColorManager.mainColor15,
              ),
            ),
            if (isRequired)
              const Text(
                '*',
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: ColorManager.borderColor),
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const SizedBox.shrink(),
              hint: _DropdownDisplayedText(
                text: hint ?? '',
              ),
              selectedItemBuilder: (context) {
                return items.map((item) {
                  return _DropdownDisplayedText(text: item);
                }).toList();
              },
              items: items.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: StylesManager.styleRegular16(context).copyWith(
                      color: ColorManager.mainColor15,
                    ),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
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
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.keyboard_arrow_down,
          color: ColorManager.greyA8AF,
          size: 22,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            textAlign: TextAlign.start,
            style: StylesManager.styleRegular16(context).copyWith(
              color: ColorManager.mainColor15,
            ),
          ),
        ),
      ],
    );
  }
}