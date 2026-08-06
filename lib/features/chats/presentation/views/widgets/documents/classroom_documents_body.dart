import 'package:bnan_app/features/chats/presentation/models/classroom_documents_tab.dart';
import 'package:bnan_app/features/chats/presentation/policies/classroom_documents_access.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/documents/classroom_documents_content.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/documents/documents_tab_loader.dart';
import 'package:flutter/material.dart';

class ClassroomDocumentsBody extends StatefulWidget {
  const ClassroomDocumentsBody({
    super.key,
    required this.roomId,
    required this.roomType,
    required this.currentUserRole,
    this.classroomId,
    this.classroomName,
  });
  final String roomId;
  final String? roomType, currentUserRole, classroomId;
  final String? classroomName;

  @override
  State<ClassroomDocumentsBody> createState() => _ClassroomDocumentsBodyState();
}

class _ClassroomDocumentsBodyState extends State<ClassroomDocumentsBody> {
  late final List<ClassroomDocumentsTab> tabs;
  late ClassroomDocumentsTab selected;

  @override
  void initState() {
    super.initState();
    final privileged = ClassroomDocumentsAccess.canRecordingsAndReports(
      roomType: widget.roomType,
      classroomId: widget.classroomId,
      role: widget.currentUserRole,
    );
    tabs = privileged
        ? ClassroomDocumentsTab.values
        : const [ClassroomDocumentsTab.messages];
    selected = tabs.first;
    loadDocumentsTab(
      context,
      selected,
      roomId: widget.roomId,
      classroomId: widget.classroomId,
    );
  }

  @override
  Widget build(BuildContext context) => ClassroomDocumentsContent(
    tabs: tabs,
    selected: selected,
    roomId: widget.roomId,
    classroomId: widget.classroomId,
    changed: (value) {
      setState(() => selected = value);
      loadDocumentsTab(
        context,
        value,
        roomId: widget.roomId,
        classroomId: widget.classroomId,
      );
    },
  );
}
