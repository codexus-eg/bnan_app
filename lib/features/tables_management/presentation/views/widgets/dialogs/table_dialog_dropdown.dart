import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class TableDialogDropdown extends StatefulWidget {
  const TableDialogDropdown({
    super.key,
    required this.label,
    required this.items,
    this.hint,
    this.initialValue,
    this.isRequired = true,
  });

  final String label;
  final List<String> items;
  final String? hint;
  final String? initialValue;
  final bool isRequired;

  @override
  State<TableDialogDropdown> createState() => _TableDialogDropdownState();
}

class _TableDialogDropdownState extends State<TableDialogDropdown> {
  late String? value = widget.initialValue;

  @override
  Widget build(BuildContext context) {
    return CustomDropdown(
      label: widget.label,
      items: widget.items,
      value: value,
      hint: widget.hint ?? widget.label,
      isRequired: widget.isRequired,
      labelColor: ColorManager.mainColor14,
      hintStyle: StylesManager.styleRegular16(
        context,
      ).copyWith(color: ColorManager.greyA8AF),
      onChanged: (newValue) => setState(() => value = newValue),
    );
  }
}
