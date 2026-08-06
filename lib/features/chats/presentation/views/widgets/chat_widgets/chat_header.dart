import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/chats/presentation/models/classroom_documents_route_args.dart';
import 'package:bnan_app/features/chats/presentation/policies/classroom_documents_access.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/chat_widgets/user_info.dart';
import 'package:flutter/material.dart';

class ChatHeader extends StatelessWidget {
  const ChatHeader({
    super.key,
    required this.chatTitle,
    required this.roomId,
    this.roomType,
    this.classroomId,
    this.currentUserRole,
  });
  final String chatTitle;
  final String roomId;
  final String? roomType;
  final String? classroomId;
  final String? currentUserRole;

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
              onPressed: () => MyNavigator.pop(context),
              icon: Icon(
                isRtl ? Icons.arrow_back : Icons.arrow_forward,
                color: ColorManager.white,
              ),
            ),
            Expanded(child: UserInfo(chatTitle: chatTitle)),
            if (ClassroomDocumentsAccess.canMessages(
              roomType: roomType,
              roomId: roomId,
              role: currentUserRole,
            ))
              IconButton(
                key: const Key('classroomDocumentsButton'),
                onPressed: () => MyNavigator.goTo(
                  context,
                  Routes.classroomDocuments,
                  extra: ClassroomDocumentsRouteArgs(
                    roomId: roomId.trim(),
                    roomType: roomType,
                    currentUserRole: currentUserRole,
                    classroomId: classroomId?.trim(),
                    classroomName: chatTitle,
                  ),
                ),
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
}
