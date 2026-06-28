import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/shared_widget/status_bar_widget.dart';
import 'package:bnan_app/features/parent_home/presentation/views/widgets/parent_home_widgets/parent_bottom_nav_bar.dart';
import 'package:bnan_app/features/parent_home/presentation/views/widgets/parent_home_widgets/parent_home_body.dart';
import 'package:bnan_app/features/parent_home/presentation/views/widgets/parent_home_widgets/parent_home_drawer.dart';
import 'package:flutter/material.dart';

class ParentHomeView extends StatefulWidget {
  const ParentHomeView({super.key});

  @override
  State<ParentHomeView> createState() => _ParentHomeViewState();
}

class _ParentHomeViewState extends State<ParentHomeView> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  int currentIndex = 0;

  static const int notificationsDrawerIndex = 5;

  static const Map<int, int> drawerToBottomNavIndex = {
    0: 0,
    1: 1,
    7: 2,
    6: 3,
    9: 4,
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
     if (index == 4) {
      MyNavigator.goTo(context, Routes.parentCertificates);
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
              ? ParentHomeDrawer(
                  onItemTap: _onDrawerItemTap,
                  onLogoutTap: _logout,
                )
              : null,
          body: ParentHomeBody(index: currentIndex, onMenuTap: _openDrawer),
          bottomNavigationBar: ParentBottomNavBar(
            currentIndex: currentIndex,
            onTap: _changeIndex,
          ),
        ),
      ),
    );
  }
}
