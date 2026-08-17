import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/core/shared_widget/status_bar_widget.dart';
import 'package:bnan_app/core/socket/socket_service.dart';
import 'package:bnan_app/features/parent_home/presentation/views/widgets/parent_home_widgets/parent_bottom_nav_bar.dart';
import 'package:bnan_app/features/parent_home/presentation/views/widgets/parent_home_widgets/parent_home_body.dart';
import 'package:bnan_app/features/parent_home/presentation/views/widgets/parent_home_widgets/parent_home_drawer.dart';
import 'package:bnan_app/features/shared_profile/presentation/manager/student_profile_cubit/student_profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bnan_app/features/dashboard/presentation/manager/dashboard_cubit.dart';

class ParentHomeView extends StatefulWidget {
  const ParentHomeView({super.key});

  @override
  State<ParentHomeView> createState() => _ParentHomeViewState();
}

class _ParentHomeViewState extends State<ParentHomeView> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  int currentIndex = 0;
  int _tabRevision = 0;
  bool _isNavigating = false;
  bool _isLoggingOut = false;

  static const int notificationsDrawerIndex = 5;

  static const Map<int, int> drawerToBottomNavIndex = {
    0: 0,
    1: 1,
    7: 2,
    6: 3,
    9: 4,
  };

  void _changeIndex(int index) {
    setState(() {
      currentIndex = index;
      _tabRevision++;
    });
    _loadTab(index);
  }

  void _loadTab(int index) {
    if (index == 0) context.read<DashboardCubit>().refresh();
    if (index == 4) StudentProfileCubit.get(context).getLoggedUser();
  }

  void _goHomeTab() {
    if (currentIndex != 0) _changeIndex(0);
  }

  void _openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  void _closeDrawer() {
    scaffoldKey.currentState?.closeDrawer();
  }

  Future<void> _onDrawerItemTap(int index) async {
    if (_isNavigating) return;
    final bottomIndex = drawerToBottomNavIndex[index];

    _closeDrawer();

    if (bottomIndex != null) {
      _changeIndex(bottomIndex);
      return;
    }

    _goHomeTab();
    _isNavigating = true;
    try {
      await _navigateFromDrawer(index);
    } finally {
      if (mounted) _loadTab(currentIndex);
      _isNavigating = false;
    }
  }

  Future<void> _navigateFromDrawer(int index) async {
    if (index == 2) {
      await MyNavigator.goTo(context, Routes.weeklyEvaluations);
    } else if (index == 3) {
      await MyNavigator.goTo(context, Routes.parentSchedule);
    } else if (index == notificationsDrawerIndex) {
      await MyNavigator.goTo(context, Routes.notification);
    } else if (index == 4) {
      await MyNavigator.goTo(context, Routes.parentCertificates);
    } else if (index == 8) {
      await MyNavigator.goTo(context, Routes.plans);
    }
  }

  Future<void> _logout() async {
    if (_isLoggingOut) return;
    _isLoggingOut = true;

    try {
      await SessionManager.instance.clearSession();
      if (await SessionManager.instance.isLoggedIn()) {
        throw StateError('Authentication session was not cleared');
      }
      getIt<SocketService>().disconnect();
      if (!mounted) return;
      MyNavigator.goToOffAll(context, Routes.logIn);
    } catch (error) {
      _isLoggingOut = false;
      if (!mounted) return;
      showCustomSnackBar(context, error.toString(), false);
    }
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
          body: ParentHomeBody(
            key: ValueKey('$currentIndex:$_tabRevision'),
            index: currentIndex,
            onMenuTap: _openDrawer,
            onShowAllChildren: () => _changeIndex(1),
          ),
          bottomNavigationBar: ParentBottomNavBar(
            currentIndex: currentIndex,
            onTap: _changeIndex,
          ),
        ),
      ),
    );
  }
}
