import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/app_logout.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/chats/presentation/notifications/chat_notification_route.dart';
import 'package:bnan_app/features/dashboard/data/models/dashboard_notification.dart';
import 'package:bnan_app/features/dashboard/data/models/supervisor_dashboard_model.dart';
import 'package:bnan_app/features/dashboard/presentation/manager/dashboard_cubit.dart';
import 'package:bnan_app/features/dashboard/presentation/widgets/dashboard_builder.dart';
import 'package:bnan_app/features/supervisor_home/presentation/config/supervisor_navigation_config.dart';
import 'package:bnan_app/features/supervisor_home/presentation/models/supervisor_home_ui_data.dart';
import 'package:bnan_app/features/supervisor_home/presentation/models/supervisor_navigation_item.dart';
import 'package:bnan_app/features/supervisor_home/presentation/views/widgets/supervisor_home_scaffold.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SupervisorHomeView extends StatefulWidget {
  const SupervisorHomeView({super.key, this.userName});
  final String? userName;
  @override
  State<SupervisorHomeView> createState() => SupervisorHomeViewState();
}

class SupervisorHomeViewState extends State<SupervisorHomeView> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoggingOut = false;

  @override
  Widget build(BuildContext context) =>
      DashboardBuilder<SupervisorDashboardModel>(
        skeleton: const SupervisorDashboardModel(
          generatedAt: null,
          classrooms: 0,
          evaluations: 0,
          idealTeacher: null,
          notifications: [],
        ),
        builder: (context, dashboard, loading) {
          final s = S.of(context);
          final drawer = SupervisorNavigationConfig.drawer(s);
          final bottom = SupervisorNavigationConfig.bottom(s);
          return SupervisorHomeScaffold(
            scaffoldKey: scaffoldKey,
            userName:
                widget.userName ??
                SessionManager.instance.userName ??
                s.supervisor,
            userSubtitle: s.supervisor,
            data: SupervisorHomeUiData.fromDashboard(s, dashboard),
            drawerItems: drawer,
            bottomItems: bottom,
            loading: loading,
            onDrawerTap: (i) => navigate(drawer[i], closeDrawer: true),
            onBottomTap: (i) => navigate(bottom[i]),
            onNotificationTap: openNotification,
            onLogoutTap: logout,
          );
        },
      );

  Future<void> navigate(
    SupervisorNavigationItem item, {
    bool closeDrawer = false,
  }) async {
    if (closeDrawer) scaffoldKey.currentState?.closeDrawer();
    if (!item.isEnabled) return;
    await MyNavigator.goTo(context, item.route!, extra: item.extra);
    if (mounted) context.read<DashboardCubit>().refresh();
  }

  void openNotification(DashboardNotification notification) {
    final chatRoute = ChatNotificationRoute.path(notification.roomId);
    MyNavigator.goTo(context, chatRoute ?? Routes.notification);
  }

  Future<void> logout() async {
    if (isLoggingOut) return;
    isLoggingOut = true;
    await AppLogout.perform(context);
    if (mounted) isLoggingOut = false;
  }
}
