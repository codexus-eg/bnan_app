import 'package:bnan_app/features/chats/data/models/classroom_recording_model.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/documents/document_card_shell.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/documents/document_link_opener.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class RecordingCard extends StatelessWidget {
  const RecordingCard({super.key, required this.item});
  final ClassroomRecordingModel item;

  @override
  Widget build(BuildContext context) => DocumentCardShell(
    icon: Icons.play_circle_outline,
    title: item.sessionName.isEmpty
        ? S.of(context).sessionRecording
        : item.sessionName,
    subtitle: S.of(context).sessionRecording,
    onTap: () => openDocumentLink(context, item.recordingLink),
  );
}
