import 'package:bnan_app/core/shared_widget/custom_app_drawer/custom_app_drawer.dart';
import 'package:bnan_app/core/shared_widget/custom_bottom_nav_bar/custom_bottom_nav_bar.dart';
import 'package:bnan_app/core/shared_widget/status_bar_widget.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/support_chat_drawer_item.dart';
import 'package:bnan_app/features/supervisor_home/presentation/models/supervisor_navigation_item.dart';
import 'package:flutter/material.dart';

class SupervisorHomeScaffold extends StatelessWidget {
  const SupervisorHomeScaffold({
    super.key,
    required this.scaffoldKey,
    required this.userName,
    required this.userSubtitle,
    required this.body,
    required this.currentIndex,
    required this.drawerItems,
    required this.bottomItems,
    required this.onDrawerTap,
    required this.onDrawerChanged,
    required this.onBottomTap,
    required this.onLogoutTap,
  });

  final GlobalKey<ScaffoldState> scaffoldKey;
  final String userName;
  final String userSubtitle;
  final Widget body;
  final int currentIndex;
  final List<SupervisorNavigationItem> drawerItems;
  final List<SupervisorNavigationItem> bottomItems;
  final ValueChanged<int> onDrawerTap;
  final DrawerCallback onDrawerChanged;
  final ValueChanged<int> onBottomTap;
  final VoidCallback onLogoutTap;

  @override
  Widget build(BuildContext context) {
    return StatusBarWidget(
      child: Scaffold(
        key: scaffoldKey,
        onDrawerChanged: onDrawerChanged,
        drawer: CustomAppDrawer(
          userName: userName,
          userSubtitle: userSubtitle,
          items: drawerItems.map((item) => item.toDrawerItem()).toList(),
          selectedIndex: 0,
          onItemTap: onDrawerTap,
          onLogoutTap: onLogoutTap,
          footer: SupportChatDrawerItem.forRole(SessionManager.instance.role),
        ),
        body: body,
        bottomNavigationBar: CustomBottomNavBar(
          items: bottomItems.map((item) => item.toBottomItem()).toList(),
          currentIndex: currentIndex,
          onTap: onBottomTap,
        ),
      ),
    );
  }
}
