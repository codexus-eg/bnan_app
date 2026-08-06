import 'package:bnan_app/features/chats/presentation/manager/classroom_recordings_cubit.dart';
import 'package:bnan_app/features/chats/presentation/manager/classroom_summaries_cubit.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/documents/classroom_documents_header.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/documents/documents_tab_content.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/documents/documents_tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClassroomDocumentsBody extends StatefulWidget {
  const ClassroomDocumentsBody({
    super.key,
    required this.classroomId,
    this.classroomName,
  });
  final String classroomId;
  final String? classroomName;

  @override
  State<ClassroomDocumentsBody> createState() => _ClassroomDocumentsBodyState();
}

class _ClassroomDocumentsBodyState extends State<ClassroomDocumentsBody> {
  int selected = 0;

  @override
  void initState() {
    super.initState();
    context.read<ClassroomRecordingsCubit>().load(widget.classroomId);
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      const ClassroomDocumentsHeader(),
      DocumentsTabs(
        selected: selected,
        changed: (value) {
          setState(() => selected = value);
          if (value == 1) {
            context.read<ClassroomSummariesCubit>().load(widget.classroomId);
          }
        },
      ),
      Expanded(
        child: DocumentsTabContent(
          classroomId: widget.classroomId,
          tab: selected,
        ),
      ),
    ],
  );
}
