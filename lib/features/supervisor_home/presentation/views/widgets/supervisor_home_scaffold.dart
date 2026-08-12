import 'package:bnan_app/core/shared_widget/custom_app_drawer/custom_app_drawer.dart';
import 'package:bnan_app/core/shared_widget/custom_bottom_nav_bar/custom_bottom_nav_bar.dart';
import 'package:bnan_app/core/shared_widget/status_bar_widget.dart';
import 'package:bnan_app/features/supervisor_home/presentation/models/supervisor_home_ui_data.dart';
import 'package:bnan_app/features/supervisor_home/presentation/models/supervisor_navigation_item.dart';
import 'package:bnan_app/features/supervisor_home/presentation/views/widgets/supervisor_home_page.dart';
import 'package:flutter/material.dart';
import 'package:bnan_app/features/dashboard/data/models/dashboard_notification.dart';

class SupervisorHomeScaffold extends StatelessWidget {
  const SupervisorHomeScaffold({
    super.key,
    required this.scaffoldKey,
    required this.userName,
    required this.userSubtitle,
    required this.data,
    required this.drawerItems,
    required this.bottomItems,
    required this.onDrawerTap,
    required this.onBottomTap,
    required this.onLogoutTap,
    required this.loading,
    required this.onNotificationTap,
  });

  final GlobalKey<ScaffoldState> scaffoldKey;
  final String userName;
  final String userSubtitle;
  final SupervisorHomeUiData data;
  final List<SupervisorNavigationItem> drawerItems;
  final List<SupervisorNavigationItem> bottomItems;
  final ValueChanged<int> onDrawerTap;
  final ValueChanged<int> onBottomTap;
  final VoidCallback onLogoutTap;
  final bool loading;
  final ValueChanged<DashboardNotification> onNotificationTap;

  @override
  Widget build(BuildContext context) {
    return StatusBarWidget(
      child: Scaffold(
        key: scaffoldKey,
        drawer: CustomAppDrawer(
          userName: userName,
          userSubtitle: userSubtitle,
          items: drawerItems.map((item) => item.toDrawerItem()).toList(),
          selectedIndex: 0,
          onItemTap: onDrawerTap,
          onLogoutTap: onLogoutTap,
        ),
        body: SupervisorHomePage(
          userName: userName,
          data: data,
          onMenuTap: () => scaffoldKey.currentState?.openDrawer(),
          loading: loading,
          onNotificationTap: onNotificationTap,
        ),
        bottomNavigationBar: CustomBottomNavBar(
          items: bottomItems.map((item) => item.toBottomItem()).toList(),
          currentIndex: 0,
          onTap: onBottomTap,
        ),
      ),
    );
  }
}
