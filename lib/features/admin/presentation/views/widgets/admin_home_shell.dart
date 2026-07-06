import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/shared_widget/status_bar_widget.dart';
import 'package:bnan_app/features/admin/presentation/views/widgets/admin_bottom_nav_bar.dart';
import 'package:bnan_app/features/admin/presentation/views/widgets/admin_home_body.dart';
import 'package:bnan_app/features/admin/presentation/views/widgets/admin_home_drawer.dart';
import 'package:flutter/material.dart';

class AdminHomeShell extends StatefulWidget {
  const AdminHomeShell({super.key});

  @override
  State<AdminHomeShell> createState() => _AdminHomeShellState();
}

class _AdminHomeShellState extends State<AdminHomeShell> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  int currentIndex = 0;
  static const int notificationsDrawerIndex = 9;

  void _changeIndex(int index) => setState(() => currentIndex = index);
  void _goHomeTab() => setState(() => currentIndex = 0);
  void _openDrawer() => scaffoldKey.currentState?.openDrawer();

  void _onDrawerItemTap(int index) {
    scaffoldKey.currentState?.closeDrawer();
     if (index == 2) {
      MyNavigator.goTo(context, Routes.teacherSubjectAssignmentView);
    }
     if (index == 5) {
      MyNavigator.goTo(context, Routes.classesManagement);
    }
    if (index == notificationsDrawerIndex) {
      MyNavigator.goTo(context, Routes.notification);
    }
  }

  void _logout() => MyNavigator.goToOffAll(context, Routes.logIn);

  @override
  Widget build(BuildContext context) {
    return StatusBarWidget(
      child: PopScope(
        canPop: currentIndex == 0,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop && currentIndex != 0) _goHomeTab();
        },
        child: Scaffold(
          key: scaffoldKey,
          drawer: currentIndex == 0
              ? AdminHomeDrawer(
                  onItemTap: _onDrawerItemTap,
                  onLogoutTap: _logout,
                )
              : null,
          body: AdminHomeBody(
            index: currentIndex,
            onMenuTap: _openDrawer,
          ),
          bottomNavigationBar: AdminBottomNavBar(
            currentIndex: currentIndex,
            onTap: _changeIndex,
          ),
        ),
      ),
    );
  }
}
