import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/chats/data/models/chat_message_model.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

enum ChatMessageMenuAction { edit, delete, select }

Future<ChatMessageMenuAction?> showChatMessageActionsSheet(
  BuildContext context, {
  required ChatMessageModel message,
  required bool canEdit,
  required bool canDelete,
}) {
  return showModalBottomSheet<ChatMessageMenuAction>(
    context: context,
    backgroundColor: ColorManager.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetContext) {
      final s = S.of(sheetContext);
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: ColorManager.greyD9D9,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              if (canEdit)
                ListTile(
                  leading: const Icon(
                    Icons.edit_outlined,
                    color: ColorManager.mainColor14,
                  ),
                  title: Text(
                    s.edit,
                    style: StylesManager.styleMedium14(sheetContext),
                  ),
                  onTap: () => Navigator.pop(
                    sheetContext,
                    ChatMessageMenuAction.edit,
                  ),
                ),
              if (canDelete)
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: ColorManager.red),
                  title: Text(
                    s.delete,
                    style: StylesManager.styleMedium14(
                      sheetContext,
                    ).copyWith(color: ColorManager.red),
                  ),
                  onTap: () => Navigator.pop(
                    sheetContext,
                    ChatMessageMenuAction.delete,
                  ),
                ),
              ListTile(
                leading: const Icon(
                  Icons.checklist_rounded,
                  color: ColorManager.grey7A7C,
                ),
                title: Text(
                  Localizations.localeOf(sheetContext).languageCode == 'ar'
                      ? 'تحديد'
                      : 'Select',
                  style: StylesManager.styleMedium14(sheetContext),
                ),
                onTap: () => Navigator.pop(
                  sheetContext,
                  ChatMessageMenuAction.select,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
