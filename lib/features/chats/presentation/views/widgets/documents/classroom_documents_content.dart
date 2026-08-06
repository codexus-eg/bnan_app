import 'package:bnan_app/features/chats/presentation/models/classroom_documents_tab.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/documents/classroom_documents_header.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/documents/documents_tab_content.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/documents/documents_tabs.dart';
import 'package:flutter/material.dart';

class ClassroomDocumentsContent extends StatelessWidget {
  const ClassroomDocumentsContent({
    super.key,
    required this.tabs,
    required this.selected,
    required this.changed,
    required this.roomId,
    this.classroomId,
  });
  final List<ClassroomDocumentsTab> tabs;
  final ClassroomDocumentsTab selected;
  final ValueChanged<ClassroomDocumentsTab> changed;
  final String roomId;
  final String? classroomId;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      const ClassroomDocumentsHeader(),
      DocumentsTabs(tabs: tabs, selected: selected, changed: changed),
      Expanded(
        child: DocumentsTabContent(
          classroomId: classroomId,
          roomId: roomId,
          tab: selected,
        ),
      ),
    ],
  );
}
