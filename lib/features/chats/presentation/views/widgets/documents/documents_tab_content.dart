import 'package:bnan_app/features/chats/presentation/models/classroom_documents_tab.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/documents/message_documents_tab.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/documents/recordings_tab.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/documents/summaries_tab.dart';
import 'package:flutter/material.dart';

class DocumentsTabContent extends StatelessWidget {
  const DocumentsTabContent({
    super.key,
    required this.roomId,
    this.classroomId,
    required this.tab,
  });

  final String roomId;
  final String? classroomId;
  final ClassroomDocumentsTab tab;

  @override
  Widget build(BuildContext context) => switch (tab) {
    ClassroomDocumentsTab.recordings => RecordingsTab(
      classroomId: classroomId!,
    ),
    ClassroomDocumentsTab.reports => SummariesTab(classroomId: classroomId!),
    ClassroomDocumentsTab.messages => MessageDocumentsTab(roomId: roomId),
  };
}
