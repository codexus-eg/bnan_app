import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class SubjectDialogDropdown extends StatefulWidget {
  const SubjectDialogDropdown({
    super.key,
    required this.label,
    required this.items,
  });

  final String label;
  final List<String> items;

  @override
  State<SubjectDialogDropdown> createState() => _SubjectDialogDropdownState();
}

class _SubjectDialogDropdownState extends State<SubjectDialogDropdown> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return CustomDropdown(
      label: widget.label,
      hint: widget.label,
      items: widget.items,
      hintStyle: StylesManager.styleMedium16(
        context,
      ).copyWith(color: ColorManager.mainColor14),
      value: selectedValue,
      onChanged: (value) => setState(() => selectedValue = value),
    );
  }
}
