import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ParentChildSelectorItem {
  const ParentChildSelectorItem({required this.id, required this.name});
  final String id, name;
}

class ParentChildSelector extends StatelessWidget {
  const ParentChildSelector({
    super.key,
    required this.children,
    required this.selectedChildId,
    required this.onChanged,
    this.selectorKey,
  });
  final List<ParentChildSelectorItem> children;
  final String? selectedChildId;
  final ValueChanged<String> onChanged;
  final Key? selectorKey;

  @override
  Widget build(BuildContext context) => CustomDropdown(
    key: selectorKey,
    label: S.of(context).child,
    value: selectedChildId,
    items: children.map((item) => item.id).toList(growable: false),
    itemsLabels: {for (final item in children) item.id: item.name},
    onChanged: (id) {
      if (id != null) onChanged(id);
    },
    useDefaultIcon: true,
  );
}
