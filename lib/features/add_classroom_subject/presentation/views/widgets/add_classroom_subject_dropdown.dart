import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class AddClassroomSubjectDropdown extends StatelessWidget {
  const AddClassroomSubjectDropdown({
    super.key,
    required this.label,
    required this.hint,
    required this.items,
    required this.labels,
    required this.value,
    required this.onChanged,
    this.loading = false,
    this.enabled = true,
  });

  final String label, hint;
  final List<String> items;
  final Map<String, String> labels;
  final String? value;
  final ValueChanged<String?> onChanged;
  final bool loading, enabled;

  @override
  Widget build(BuildContext context) => CustomDropdown(
    label: label,
    hint: loading ? S.of(context).loading : hint,
    value: value,
    items: enabled && !loading ? items : null,
    itemsLabels: labels,
    onChanged: onChanged,
    useDefaultIcon: true,
  );
}
