import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/chats/presentation/models/classroom_documents_route_args.dart';
import 'package:bnan_app/features/chats/presentation/policies/classroom_documents_access.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/chat_widgets/user_info.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ChatHeader extends StatelessWidget {
  const ChatHeader({
    super.key,
    required this.chatTitle,
    required this.roomId,
    this.roomType,
    this.classroomId,
    this.currentUserRole,
    this.onMessageTarget,
    this.selectedCount = 0,
    this.isDeleting = false,
    this.onCancelSelection,
    this.onDeleteSelection,
  });
  final String chatTitle;
  final String roomId;
  final String? roomType;
  final String? classroomId;
  final String? currentUserRole;
  final ValueChanged<String>? onMessageTarget;
  final int selectedCount;
  final bool isDeleting;
  final VoidCallback? onCancelSelection;
  final VoidCallback? onDeleteSelection;

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Container(
      width: double.infinity,
      padding: const EdgeInsetsDirectional.only(
        top: 19,
        // start: 16,
        end: 16,
        bottom: 19,
      ),
      decoration: const BoxDecoration(
        color: ColorManager.mainColor14,
        borderRadius: BorderRadiusDirectional.only(
          bottomStart: Radius.circular(10),
          bottomEnd: Radius.circular(10),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            IconButton(
              onPressed: selectedCount > 0
                  ? onCancelSelection
                  : () => MyNavigator.pop(context),
              icon: Icon(
                selectedCount > 0
                    ? Icons.close
                    : isRtl
                    ? Icons.arrow_back
                    : Icons.arrow_forward,
                color: ColorManager.white,
              ),
            ),
            Expanded(
              child: selectedCount > 0
                  ? Text(
                      '$selectedCount ${S.of(context).selectedMessagesLabel}',
                      style: const TextStyle(color: ColorManager.white),
                    )
                  : UserInfo(chatTitle: chatTitle),
            ),
            if (selectedCount > 0)
              IconButton(
                onPressed: isDeleting ? null : onDeleteSelection,
                icon: isDeleting
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: ColorManager.white,
                        ),
                      )
                    : const Icon(
                        Icons.delete_outline,
                        color: ColorManager.white,
                      ),
              )
            else if (ClassroomDocumentsAccess.canMessages(
              roomType: roomType,
              roomId: roomId,
              role: currentUserRole,
            ))
              IconButton(
                key: const Key('classroomDocumentsButton'),
                onPressed: () => _openDocuments(context),
                icon: const Icon(
                  Icons.folder_copy_outlined,
                  color: ColorManager.white,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _openDocuments(BuildContext context) async {
    final messageId = await MyNavigator.goTo<String>(
      context,
      Routes.classroomDocuments,
      extra: ClassroomDocumentsRouteArgs(
        roomId: roomId.trim(),
        roomType: roomType,
        currentUserRole: currentUserRole,
        classroomId: classroomId?.trim(),
        classroomName: chatTitle,
      ),
    );
    if (messageId?.trim().isNotEmpty == true) onMessageTarget?.call(messageId!);
  }
}
