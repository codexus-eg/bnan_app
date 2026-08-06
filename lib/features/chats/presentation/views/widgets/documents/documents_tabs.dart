import 'package:bnan_app/core/shared_widget/filter_chip/custom_filter_tabs.dart';
import 'package:bnan_app/features/chats/presentation/models/classroom_documents_tab.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class DocumentsTabs extends StatelessWidget {
  const DocumentsTabs({
    super.key,
    required this.tabs,
    required this.selected,
    required this.changed,
  });
  final List<ClassroomDocumentsTab> tabs;
  final ClassroomDocumentsTab selected;
  final ValueChanged<ClassroomDocumentsTab> changed;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(16),
    child: CustomFilterTabs<ClassroomDocumentsTab>(
      items: {
        for (final tab in tabs)
          tab: switch (tab) {
            ClassroomDocumentsTab.recordings => S.of(context).recordings,
            ClassroomDocumentsTab.reports => S.of(context).reports,
            ClassroomDocumentsTab.messages => S.of(context).messages,
          },
      },
      selectedItem: selected,
      onChanged: changed,
    ),
  );
}
