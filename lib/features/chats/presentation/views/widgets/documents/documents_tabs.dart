import 'package:bnan_app/core/shared_widget/filter_chip/custom_filter_tabs.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class DocumentsTabs extends StatelessWidget {
  const DocumentsTabs({
    super.key,
    required this.selected,
    required this.changed,
  });
  final int selected;
  final ValueChanged<int> changed;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(16),
    child: CustomFilterTabs<int>(
      items: {0: S.of(context).recordings, 1: S.of(context).reports},
      selectedItem: selected,
      onChanged: changed,
    ),
  );
}
