import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/chats/data/repo/chat_repo.dart';
import 'package:bnan_app/features/chats/presentation/models/chat_route_args.dart';
import 'package:bnan_app/features/chats/presentation/policies/supervisor_student_chat_access.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract final class SupervisorStudentChatLauncher {
  static bool _isOpening = false;

  static Future<void> open(BuildContext context, String studentId) async {
    final id = studentId.trim();
    if (_isOpening || id.isEmpty) return;
    _isOpening = true;
    final router = GoRouter.of(context);
    final s = S.of(context);
    final result = await getIt<ChatRepo>().openSupervisorStudentRoom(
      studentId: id,
    );
    if (!context.mounted) {
      _isOpening = false;
      return;
    }
    result.fold(
      (failure) => showCustomSnackBar(
        context,
        isChatAccessDenied(failure) ? s.errorForbidden : failure.message,
        false,
      ),
      (response) {
        final roomId = response.room.id.trim();
        if (roomId.isEmpty) {
          showCustomSnackBar(context, s.unexpectedError, false);
          return;
        }
        router.push(
          Routes.chatPath(roomId),
          extra: ChatRouteArgs(
            roomType: response.room.type,
            currentUserRole: SessionManager.instance.userRole,
          ),
        );
      },
    );
    _isOpening = false;
  }
}
