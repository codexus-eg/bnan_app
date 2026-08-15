import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/app_logout.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/session/current_user_ui.dart';
import 'package:bnan_app/features/chats/presentation/notifications/chat_notification_route.dart';
import 'package:bnan_app/features/dashboard/data/models/dashboard_notification.dart';
import 'package:bnan_app/features/dashboard/data/models/supervisor_dashboard_model.dart';
import 'package:bnan_app/features/dashboard/presentation/widgets/dashboard_builder.dart';
import 'package:bnan_app/features/supervisor_home/presentation/config/supervisor_navigation_config.dart';
import 'package:bnan_app/features/supervisor_home/presentation/models/supervisor_home_ui_data.dart';
import 'package:bnan_app/features/supervisor_home/presentation/models/supervisor_navigation_item.dart';
import 'package:bnan_app/features/supervisor_home/presentation/views/widgets/supervisor_home_scaffold.dart';
import 'package:bnan_app/features/supervisor_home/presentation/views/widgets/supervisor_bottom_tab_body.dart';
import 'package:bnan_app/features/supervisor_home/presentation/views/widgets/supervisor_drawer_root_body.dart';
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
  final Map<String, Widget> _drawerRoots = {};
  bool isLoggingOut = false;
  int selectedBottomIndex = 0;
  String? selectedDrawerRoute;

  @override
  Widget build(
    BuildContext context,
  ) => DashboardBuilder<SupervisorDashboardModel>(
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
      final drawerRoutes = _drawerRoots.keys.toList(growable: false);
      final userName = widget.userName ?? CurrentUserUi.name(context);
      final home = SupervisorHomePage(
        userName: userName,
        data: SupervisorHomeUiData.fromDashboard(s, dashboard),
        onMenuTap: () => scaffoldKey.currentState?.openDrawer(),
        loading: loading,
        onNotificationTap: openNotification,
      );
      return PopScope(
        canPop:
            selectedBottomIndex == homeTabIndex && selectedDrawerRoute == null,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) selectHome();
        },
        child: SupervisorHomeScaffold(
          scaffoldKey: scaffoldKey,
          userName: userName,
          userSubtitle: CurrentUserUi.role(context),
          body: IndexedStack(
            index: selectedDrawerRoute == null
                ? selectedBottomIndex
                : bottom.length + drawerRoutes.indexOf(selectedDrawerRoute!),
            children: [
              ...List.generate(
                bottom.length,
                (index) => index == homeTabIndex
                    ? home
                    : _tabs[index] ?? const SizedBox.shrink(),
              ),
              ...drawerRoutes.map((route) => _drawerRoots[route]!),
            ],
          ),
          currentIndex: selectedDrawerRoute == null ? selectedBottomIndex : -1,
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
    if (index == selectedBottomIndex && selectedDrawerRoute == null) return;
    if (index == homeTabIndex) {
      selectHome();
      return;
    }
    if (!item.isEnabled) return;
    _tabs.putIfAbsent(
      index,
      () => (widget.tabBuilder ?? buildSupervisorBottomTab)(item.route!),
    );
    setState(() {
      selectedBottomIndex = index;
      selectedDrawerRoute = null;
    });
  }

  void selectHome() => setState(() {
    selectedBottomIndex = homeTabIndex;
    selectedDrawerRoute = null;
  });

  void selectDrawerRoot(
    SupervisorNavigationItem item,
    List<SupervisorNavigationItem> bottom,
  ) {
    scaffoldKey.currentState?.closeDrawer();
    if (item.route == Routes.tablesManagement) {
      MyNavigator.goTo(context, Routes.tablesManagement);
      return;
    }
    final bottomIndex = bottom.indexWhere((entry) => entry.route == item.route);
    if (item.route == null || bottomIndex == homeTabIndex) {
      selectHome();
      return;
    }
    if (bottomIndex > homeTabIndex) {
      selectBottomTab(bottomIndex, bottom[bottomIndex]);
      return;
    }
    _drawerRoots.putIfAbsent(
      item.route!,
      () => (widget.tabBuilder ?? buildSupervisorDrawerRoot)(item.route!),
    );
    setState(() => selectedDrawerRoute = item.route);
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
