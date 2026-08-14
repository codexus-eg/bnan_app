import 'package:bnan_app/core/app_routes/routes.dart';

abstract final class ChatRoleNavigation {
  static const messagesRoute = Routes.groups;
  static const adminDrawerIndex = 9;
  static const studentDrawerIndex = 11;

  static bool isTeacherMessagesIndex(int index, int itemCount) {
    return itemCount > 0 && index == itemCount - 1;
  }
}
