import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/app_logout.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/core/session/current_user_ui.dart';
import 'package:bnan_app/features/dashboard/data/models/dashboard_notification.dart';
import 'package:bnan_app/features/dashboard/data/models/supervisor_dashboard_model.dart';
import 'package:bnan_app/features/dashboard/presentation/widgets/dashboard_builder.dart';
import 'package:bnan_app/features/notifications/data/models/app_notification.dart';
import 'package:bnan_app/features/notifications/domain/notification_navigation_service.dart';
import 'package:bnan_app/features/supervisor_home/presentation/config/supervisor_navigation_config.dart';
import 'package:bnan_app/features/supervisor_home/presentation/models/supervisor_home_ui_data.dart';
import 'package:bnan_app/features/supervisor_home/presentation/models/supervisor_navigation_item.dart';
import 'package:bnan_app/features/supervisor_home/presentation/views/widgets/supervisor_home_scaffold.dart';
import 'package:bnan_app/features/supervisor_home/presentation/views/widgets/supervisor_bottom_tab_body.dart';
import 'package:bnan_app/features/supervisor_home/presentation/views/widgets/supervisor_home_page.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

typedef SupervisorTabBuilder = Widget Function(String route);

class SupervisorHomeView extends StatefulWidget {
  const SupervisorHomeView({super.key, this.userName, this.tabBuilder});
  final String? userName;
  final SupervisorTabBuilder? tabBuilder;
  @override
  State<SupervisorHomeView> createState() => SupervisorHomeViewState();
}

class SupervisorHomeViewState extends State<SupervisorHomeView> {
  static const homeTabIndex = 0;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final Map<int, Widget> _tabs = {};
  bool isLoggingOut = false;
  int selectedBottomIndex = 0;

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
          final userName = widget.userName ?? CurrentUserUi.name(context);
          final home = SupervisorHomePage(
            userName: userName,
            data: SupervisorHomeUiData.fromDashboard(s, dashboard),
            onMenuTap: () => scaffoldKey.currentState?.openDrawer(),
            loading: loading,
          );
          return PopScope(
            canPop: selectedBottomIndex == homeTabIndex,
            onPopInvokedWithResult: (didPop, result) {
              if (!didPop) selectHome();
            },
            child: SupervisorHomeScaffold(
              scaffoldKey: scaffoldKey,
              userName: userName,
              userSubtitle: CurrentUserUi.role(context),
              body: IndexedStack(
                index: selectedBottomIndex,
                children: List.generate(
                  bottom.length,
                  (index) => index == homeTabIndex
                      ? home
                      : _tabs[index] ?? const SizedBox.shrink(),
                ),
              ),
              currentIndex: selectedBottomIndex,
              drawerItems: drawer,
              bottomItems: bottom,
              onDrawerTap: (i) => selectDrawerRoot(drawer[i], bottom),
              onBottomTap: (i) => selectBottomTab(i, bottom[i]),
              onLogoutTap: logout,
            ),
          );
        },
      );

  void selectBottomTab(int index, SupervisorNavigationItem item) {
    if (index == selectedBottomIndex) return;
    if (index == homeTabIndex) {
      selectHome();
      return;
    }
    if (!item.isEnabled) return;
    _tabs.putIfAbsent(
      index,
      () => (widget.tabBuilder ?? buildSupervisorBottomTab)(item.route!),
    );
    setState(() => selectedBottomIndex = index);
  }

  void selectHome() {
    if (selectedBottomIndex == homeTabIndex) return;
    setState(() => selectedBottomIndex = homeTabIndex);
  }

  void selectDrawerRoot(
    SupervisorNavigationItem item,
    List<SupervisorNavigationItem> bottom,
  ) {
    scaffoldKey.currentState?.closeDrawer();
    final bottomIndex = bottom.indexWhere((entry) => entry.route == item.route);
    if (item.route == null || bottomIndex == homeTabIndex) {
      selectHome();
      return;
    }
    if (bottomIndex > homeTabIndex) {
      selectBottomTab(bottomIndex, bottom[bottomIndex]);
      return;
    }
    MyNavigator.goTo(context, item.route!, extra: item.extra);
  }

  Future<void> openNotification(DashboardNotification notification) async {
    final rawData = {
      'title': notification.title,
      'type': notification.type,
      'isRead': notification.isRead,
      'resource': notification.resource,
      'data': notification.data,
      'key': notification.data['key'] ?? notification.type,
      'navigation': notification.data['navigation'] ?? {},
    };
    final appNotification = AppNotification.fromJson(rawData);
    final destination = await getIt<NotificationNavigationService>()
        .resolveDestination(appNotification);
    if (!mounted) return;
    if (destination.path == Routes.notification) {
      MyNavigator.goTo(context, Routes.notification);
      return;
    }
    MyNavigator.goTo(context, destination.path, extra: destination.extra);
  }

  Future<void> logout() async {
    if (isLoggingOut) return;
    isLoggingOut = true;
    await AppLogout.perform(context);
    if (mounted) isLoggingOut = false;
  }
}
