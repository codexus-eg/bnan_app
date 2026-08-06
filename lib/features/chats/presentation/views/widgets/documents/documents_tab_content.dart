import 'package:bnan_app/features/chats/presentation/views/widgets/documents/recordings_tab.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/documents/summaries_tab.dart';
import 'package:flutter/material.dart';

class DocumentsTabContent extends StatelessWidget {
  const DocumentsTabContent({
    super.key,
    required this.classroomId,
    required this.tab,
  });

  final String classroomId;
  final int tab;

  @override
  Widget build(BuildContext context) => IndexedStack(
    index: tab,
    children: [
      RecordingsTab(classroomId: classroomId),
      SummariesTab(classroomId: classroomId),
    ],
  );
}
