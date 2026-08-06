import 'package:bnan_app/features/chats/presentation/models/message_document_item.dart';
import 'package:bnan_app/features/chats/presentation/utils/classroom_document_opener.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/chat_bubble/chat_formatters.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/documents/document_card_shell.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/documents/document_link_opener.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/documents/message_document_icon.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class MessageDocumentCard extends StatelessWidget {
  const MessageDocumentCard({super.key, required this.item, this.opener});
  final MessageDocumentItem item;
  final ClassroomDocumentOpener? opener;

  @override
  Widget build(BuildContext context) {
    final title = item.fileName.isNotEmpty
        ? item.fileName
        : item.messageTitle.isNotEmpty
        ? item.messageTitle
        : S.of(context).messageDocuments;
    final details = <String>[
      if (item.senderName.isNotEmpty) item.senderName,
      if (item.mimeType.isNotEmpty) item.mimeType,
      if (item.size > 0) ChatFormatters.formatFileSize(item.size),
      if (item.createdAt != null) _dateTime(item.createdAt!),
    ];
    return DocumentCardShell(
      icon: messageDocumentIcon(item),
      title: title,
      subtitle: details.join(' • '),
      preview: item.fileName.isNotEmpty && item.messageTitle.isNotEmpty
          ? item.messageTitle
          : null,
      onTap: () => openDocumentLink(context, item.url, opener: opener),
    );
  }

  String _dateTime(DateTime value) {
    final local = value.toLocal();
    final date =
        '${local.day.toString().padLeft(2, '0')}/'
        '${local.month.toString().padLeft(2, '0')}/${local.year}';
    return '$date ${ChatFormatters.formatTime(local)}';
  }
}
