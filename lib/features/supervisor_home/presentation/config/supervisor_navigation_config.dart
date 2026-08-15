import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/features/chats/presentation/navigation/chat_role_navigation.dart';
import 'package:bnan_app/features/supervisor_home/presentation/models/supervisor_navigation_item.dart';
import 'package:bnan_app/generated/l10n.dart';

abstract class SupervisorNavigationConfig {
  static List<SupervisorNavigationItem> drawer(S s) {
    final session = SessionManager.instance;
    return [
      _item(s.home, ImageManager.homeIcon),
      if (session.isEgyptianSupervisor)
        _item(
          s.schedule,
          ImageManager.tableIcon,
          Routes.egyptianSchedulesReadOnly,
        ),
      if (session.isEgyptianSupervisor)
        _item(
          s.lessonsManagement,
          ImageManager.calendarIcon,
          Routes.tablesManagement,
        ),
      if (session.isGulfSupervisor)
        _item(
          s.lessonsManagement,
          ImageManager.calendarIcon,
          Routes.lessonsManagement,
        ),
      _item(s.evaluations, ImageManager.starIcon, Routes.weeklyEvaluations),
      _item(
        s.certificates,
        ImageManager.certificateBadgeIcon,
        Routes.certificatesManagement,
      ),
      _item(
        s.messages,
        ImageManager.chatIcon,
        ChatRoleNavigation.messagesRoute,
      ),
      _item(s.attendance, ImageManager.userCheck, Routes.attendance),
      _item(s.plansTitle, ImageManager.calendarIcon, Routes.plans),
      if (session.isEgyptianSupervisor)
        _item(
          s.weeklyIdealStudent,
          ImageManager.crownSimple,
          Routes.weeklyIdealStudents,
        ),
      _item(s.idealTeacher, ImageManager.crownSimple, Routes.idealTeacher),
    ];
  }

  static List<SupervisorNavigationItem> bottom(S s) {
    return [
      _item(s.home, ImageManager.homeIcon),
      _item(s.evaluations, ImageManager.starIcon, Routes.weeklyEvaluations),
      _item(
        s.messages,
        ImageManager.chatIcon,
        ChatRoleNavigation.messagesRoute,
      ),
      _item(
        s.certificates,
        ImageManager.certificateBadgeIcon,
        Routes.certificatesManagement,
      ),
      _item(s.attendance, ImageManager.userCheck, Routes.attendance),
    ];
  }

  static SupervisorNavigationItem _item(
    String title,
    String icon, [
    String? route,
    Object? extra,
  ]) {
    return SupervisorNavigationItem(
      title: title,
      icon: icon,
      route: route,
      extra: extra,
    );
  }
}
