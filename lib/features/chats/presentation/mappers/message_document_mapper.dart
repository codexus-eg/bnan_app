import 'package:bnan_app/core/helper/file_url_launcher.dart';
import 'package:bnan_app/features/chats/data/models/chat_message_model.dart';
import 'package:bnan_app/features/chats/presentation/models/message_document_item.dart';
import 'package:bnan_app/features/chats/presentation/utils/chat_attachment_url.dart';

class MessageDocumentMapper {
  const MessageDocumentMapper._();

  static List<MessageDocumentItem> fromMessages(
    List<ChatMessageModel> messages,
  ) {
    return messages.expand(_fromMessage).toList(growable: false);
  }

  static Iterable<MessageDocumentItem> _fromMessage(
    ChatMessageModel message,
  ) sync* {
    if (message.deletedForEveryone) return;
    for (final attachment in message.attachments) {
      final url = attachment.fileUrl.trim();
      if (ChatAttachmentUrl.resolve(url) == null) continue;
      yield MessageDocumentItem(
        id: '${message.id}:${attachment.id}',
        messageId: message.id,
        url: url,
        fileName: attachment.fileName.trim(),
        messageTitle: message.text.trim(),
        senderName: message.sender.fullName.trim(),
        mimeType: attachment.mimeType.trim(),
        size: attachment.size,
        createdAt: message.createdAt,
        isExternalLink: false,
      );
    }
    final text = message.text.trim();
    if (FileUrlLauncher.isValidWebUrl(text)) {
      yield MessageDocumentItem(
        id: '${message.id}:link',
        messageId: message.id,
        url: text,
        fileName: '',
        messageTitle: text,
        senderName: message.sender.fullName.trim(),
        mimeType: 'text/uri-list',
        size: 0,
        createdAt: message.createdAt,
        isExternalLink: true,
      );
    }
  }
}
