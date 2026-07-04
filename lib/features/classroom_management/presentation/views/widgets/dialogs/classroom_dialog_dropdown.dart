import 'package:bnan_app/core/shared_widget/custom_dropdown_form_field.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class ClassroomDialogDropdown extends StatefulWidget {
  const ClassroomDialogDropdown({
    super.key,
    required this.label,
    required this.items,
    required this.initialValue,
  });

  final String label;
  final String initialValue;
  final List<String> items;

  @override
  State<ClassroomDialogDropdown> createState() =>
      _ClassroomDialogDropdownState();
}

class _ClassroomDialogDropdownState extends State<ClassroomDialogDropdown> {
  late String selectedValue = widget.initialValue;

  @override
  Widget build(BuildContext context) {
    return CustomDropdownFormField(
      label: widget.label,
      value: selectedValue,
      hint: selectedValue,
      items: widget.items,
      hintStyle: StylesManager.styleRegular16(context),
      onChanged: (value) => setState(
        () => selectedValue = value ?? selectedValue,
      ),
    );
  }
}
