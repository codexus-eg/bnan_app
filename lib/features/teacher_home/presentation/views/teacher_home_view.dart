import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/app_logout.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/core/shared_widget/status_bar_widget.dart';
import 'package:bnan_app/core/socket/socket_service.dart';
import 'package:bnan_app/features/teacher_home/presentation/views/widgets/teacher_home_widgets/teacher_bottom_nav_bar.dart';
import 'package:bnan_app/features/chats/presentation/navigation/chat_role_navigation.dart';
import 'package:bnan_app/features/teacher_home/presentation/views/widgets/teacher_home_widgets/teacher_drawer_items.dart';
import 'package:bnan_app/features/teacher_home/presentation/views/widgets/teacher_home_widgets/teacher_home_body.dart';
import 'package:bnan_app/features/teacher_home/presentation/views/widgets/teacher_home_widgets/teacher_home_drawer.dart';
import 'package:bnan_app/features/dashboard/presentation/manager/dashboard_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class TeacherHomeView extends StatefulWidget {
  const TeacherHomeView({super.key, this.initialIndex = 0});
  final int initialIndex;

  @override
  State<TeacherHomeView> createState() => _TeacherHomeViewState();
}

class _TeacherHomeViewState extends State<TeacherHomeView> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  late int currentIndex;
  bool _isLoggingOut = false;

  static const int notificationsDrawerIndex = 7;
  static const int plansDrawerIndex = 6;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _loadTab(currentIndex);
    });
  }

  void _changeIndex(int index) {
    if (index == currentIndex) return;
    setState(() => currentIndex = index);
    _loadTab(index);
  }

  void _loadTab(int index) {
    if (index == 0) context.read<DashboardCubit>().load();
  }

  void _goHomeTab() => _changeIndex(0);

  void _openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  void _closeDrawer() {
    scaffoldKey.currentState?.closeDrawer();
  }

  void _onDrawerItemTap(int index) {
    final drawerItemCount = teacherDrawerItems(context).length;
    final scheduleRoutes = teacherScheduleRoutes();
    const scheduleStartIndex = 1;
    final scheduleIndex = index - scheduleStartIndex;

    _closeDrawer();

    if (ChatRoleNavigation.isTeacherMessagesIndex(index, drawerItemCount)) {
      _changeIndex(teacherMessagesTabIndex);
      return;
    }

    if (scheduleIndex >= 0 && scheduleIndex < scheduleRoutes.length) {
      _goHomeTab();
      MyNavigator.goTo(context, scheduleRoutes[scheduleIndex]);
      return;
    }

    final legacyIndex = index < scheduleStartIndex
        ? index
        : index - scheduleRoutes.length + 1;
    final bottomIndex = teacherDrawerToBottomNavIndex[legacyIndex];

    if (bottomIndex != null) {
      _changeIndex(bottomIndex);
      return;
    }

    _goHomeTab();
    _navigateFromDrawer(legacyIndex);
  }

  void _navigateFromDrawer(int index) {
    if (index == 2) {
      MyNavigator.goTo(context, Routes.weeklyEvaluations);
    } else if (index == 4) {
      MyNavigator.goTo(context, Routes.teacherRegistrationRequest);
    } else if (index == 5) {
      MyNavigator.goTo(context, Routes.teacherMyEarnings);
    } else if (index == notificationsDrawerIndex) {
      MyNavigator.goTo(context, Routes.notification);
    } else if (index == plansDrawerIndex) {
      MyNavigator.goTo(context, Routes.plans);
    } else if (index == 8) {
      MyNavigator.goTo(context, Routes.attendance);
    } else if (index == 10) {
      MyNavigator.goTo(context, Routes.weeklyIdealStudents);
    }
  }

  void _onBottomNavTap(int index) => _changeIndex(index);

  Future<void> _logout() async {
    if (_isLoggingOut) return;
    _isLoggingOut = true;

    try {
      await SessionManager.instance.clearSession();
      if (await SessionManager.instance.isLoggedIn()) {
        throw StateError('Authentication session was not cleared');
      }
      getIt<SocketService>().disconnect();
      final destination = await AppLogout.destinationAfterLogout();
      if (!mounted) return;
      MyNavigator.goToOffAll(context, destination);
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
              ? TeacherHomeDrawer(
                  onItemTap: _onDrawerItemTap,
                  onLogoutTap: _logout,
                )
              : null,
          body: TeacherHomeBody(
            key: ValueKey(currentIndex),
            index: currentIndex,
            onMenuTap: _openDrawer,
          ),
          bottomNavigationBar: TeacherBottomNavBar(
            currentIndex: currentIndex,
            onTap: _onBottomNavTap,
          ),
        ),
      ),
    );
  }
}

const teacherMessagesTabIndex = 2;
const teacherPayrollTabIndex = teacherMessagesTabIndex;
const teacherDrawerToBottomNavIndex = <int, int>{0: 0, 3: 1, 9: 4};
