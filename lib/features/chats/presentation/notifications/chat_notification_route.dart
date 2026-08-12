import 'package:bnan_app/core/app_routes/routes.dart';

abstract final class ChatNotificationRoute {
  static String? path(String? roomId) {
    final value = roomId?.trim();
    return value?.isNotEmpty == true ? Routes.chatPath(value!) : null;
  }
}
