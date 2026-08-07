import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/features/parent_home/presentation/manager/get_parent_children/get_parent_children_state.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ParentChildrenCertificatesFilter extends StatelessWidget {
  const ParentChildrenCertificatesFilter({
    super.key,
    required this.state,
    required this.onChanged,
  });

  final GetParentChildrenSuccess state;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(vertical: 16),
      child: CustomDropdown(
        key: const Key('parentCertificatesChildDropdown'),
        label: S.of(context).child,
        value: state.selectedChildId,
        items: state.children.map((child) => child.id).toList(growable: false),
        itemsLabels: {
          for (final child in state.children) child.id: child.fullName,
        },
        onChanged: (id) {
          if (id != null) onChanged(id);
        },
        useDefaultIcon: true,
      ),
    );
  }
}
