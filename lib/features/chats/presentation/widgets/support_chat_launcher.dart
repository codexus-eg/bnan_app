import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/core/shared_widget/app_top_feedback/app_top_feedback.dart';
import 'package:bnan_app/features/chats/data/repo/chat_repo.dart';
import 'package:bnan_app/features/chats/presentation/models/chat_route_args.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract final class SupportChatLauncher {
  static bool _isOpening = false;

  static Future<void> open(BuildContext context) async {
    if (_isOpening) return;
    _isOpening = true;
    final router = GoRouter.of(context);
    final s = S.of(context);
    final feedback = AppTopFeedback.show(
      context,
      type: AppTopFeedbackType.loading,
      title: s.contactUs,
      showClose: false,
    );

    final result = await getIt<ChatRepo>().createSupportRoom();
    if (!context.mounted) {
      AppTopFeedback.dismiss(feedback);
      _isOpening = false;
      return;
    }

    result.fold(
      (failure) => AppTopFeedback.replace(
        context,
        feedback,
        type: AppTopFeedbackType.error,
        title: failure.message,
      ),
      (response) {
        final roomId = response.room.id.trim();
        if (roomId.isEmpty) {
          AppTopFeedback.replace(
            context,
            feedback,
            type: AppTopFeedbackType.error,
            title: s.unexpectedError,
          );
          return;
        }
        AppTopFeedback.dismiss(feedback);
        Navigator.of(context).pop();
        router.push(
          Routes.chatPath(roomId),
          extra: ChatRouteArgs(
            roomType: response.room.type,
            classroomName: s.contactUs,
            currentUserRole: SessionManager.instance.userRole,
          ),
        );
      },
    );
    _isOpening = false;
  }
}
