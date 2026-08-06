import 'package:bnan_app/features/chats/presentation/manager/classroom_recordings_cubit.dart';
import 'package:bnan_app/features/chats/presentation/manager/classroom_summaries_cubit.dart';
import 'package:bnan_app/features/chats/presentation/manager/message_documents_cubit.dart';
import 'package:bnan_app/features/chats/presentation/models/classroom_documents_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void loadDocumentsTab(
  BuildContext context,
  ClassroomDocumentsTab tab, {
  required String roomId,
  required String? classroomId,
}) {
  switch (tab) {
    case ClassroomDocumentsTab.recordings:
      context.read<ClassroomRecordingsCubit>().load(classroomId!);
    case ClassroomDocumentsTab.reports:
      context.read<ClassroomSummariesCubit>().load(classroomId!);
    case ClassroomDocumentsTab.messages:
      context.read<MessageDocumentsCubit>().load(roomId);
  }
}
