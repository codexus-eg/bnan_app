import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/shared_widget/status_bar_widget.dart';
import 'package:bnan_app/features/teacher_home/presentation/views/widgets/teacher_home_widgets/teacher_bottom_nav_bar.dart';
import 'package:bnan_app/features/teacher_home/presentation/views/widgets/teacher_home_widgets/teacher_home_body.dart';
import 'package:bnan_app/features/teacher_home/presentation/views/widgets/teacher_home_widgets/teacher_home_drawer.dart';
import 'package:flutter/material.dart';

class TeacherHomeView extends StatefulWidget {
  const TeacherHomeView({super.key});

  @override
  State<TeacherHomeView> createState() => _TeacherHomeViewState();
}

class _TeacherHomeViewState extends State<TeacherHomeView> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  int currentIndex = 0;

  static const int notificationsDrawerIndex = 13;

  static const Map<int, int> drawerToBottomNavIndex = {
    0: 0,
    3: 1,
    5: 2,
    8: 3,
    14: 4,
  };

  void _changeIndex(int index) {
    setState(() => currentIndex = index);
  }

  void _goHomeTab() {
    setState(() => currentIndex = 0);
  }

  void _openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  void _closeDrawer() {
    scaffoldKey.currentState?.closeDrawer();
  }

  void _onDrawerItemTap(int index) {
    final bottomIndex = drawerToBottomNavIndex[index];

    _closeDrawer();

    if (bottomIndex != null) {
      _changeIndex(bottomIndex);
      return;
    }

    _goHomeTab();
    _navigateFromDrawer(index);
  }

  void _navigateFromDrawer(int index) {
    if (index == notificationsDrawerIndex) {
      MyNavigator.goTo(context, Routes.notification);
    }
  }

  void _logout() {
    MyNavigator.goToOffAll(context, Routes.logIn);
  }

  @override
  Widget build(BuildContext context) {
    return StatusBarWidget(
      child: PopScope(
        canPop: currentIndex == 0,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
      
          if (currentIndex != 0) {
            _goHomeTab();
          }
        },
        child: Scaffold(
          key: scaffoldKey,
          drawer: currentIndex == 0
              ? TeacherHomeDrawer(
                  onItemTap: _onDrawerItemTap,
                  onLogoutTap: _logout,
                )
              : null,
          body: TeacherHomeBody(
            index: currentIndex,
            onMenuTap: _openDrawer,
          ),
          bottomNavigationBar: TeacherBottomNavBar(
            currentIndex: currentIndex,
            onTap: _changeIndex,
          ),
        ),
      ),
    );
  }
}