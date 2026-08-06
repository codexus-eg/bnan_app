import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/features/chats/presentation/utils/classroom_document_opener.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

enum DocumentLinkKind { file, document, recording }

Future<void> openDocumentLink(
  BuildContext context,
  String? link, {
  DocumentLinkKind kind = DocumentLinkKind.file,
  ClassroomDocumentOpener? opener,
}) async {
  final result = await (opener ?? defaultClassroomDocumentOpener).open(link);
  if (!context.mounted ||
      result == DocumentOpenResult.opened ||
      result == DocumentOpenResult.busy) {
    return;
  }
  final strings = S.of(context);
  final message = switch (result) {
    DocumentOpenResult.invalid => strings.invalidLink,
    _ => switch (kind) {
      DocumentLinkKind.file => strings.unableToOpenFile,
      DocumentLinkKind.document => strings.unableToOpenDocument,
      DocumentLinkKind.recording => strings.unableToOpenSessionRecording,
    },
  };
  showCustomSnackBar(context, message, false);
}
