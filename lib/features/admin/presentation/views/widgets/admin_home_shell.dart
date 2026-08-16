import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/core/shared_widget/status_bar_widget.dart';
import 'package:bnan_app/core/socket/socket_service.dart';
import 'package:bnan_app/features/admin/presentation/views/widgets/admin_bottom_nav_bar.dart';
import 'package:bnan_app/features/admin/presentation/views/widgets/admin_home_body.dart';
import 'package:bnan_app/features/admin/presentation/views/widgets/admin_home_drawer.dart';
import 'package:bnan_app/features/chats/presentation/navigation/chat_role_navigation.dart';
import 'package:bnan_app/features/dashboard/presentation/manager/dashboard_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminHomeShell extends StatefulWidget {
  const AdminHomeShell({super.key});

  @override
  State<AdminHomeShell> createState() => _AdminHomeShellState();
}

class _AdminHomeShellState extends State<AdminHomeShell> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  int currentIndex = 0;
  bool _isLoggingOut = false;
  static const int subjectAssignmentDrawerIndex = 2;
  static const int classesDrawerIndex = 5;
  static const int notificationsDrawerIndex = 10;
  static const int addClassroomSubjectDrawerIndex = 18;

  void _changeIndex(int index) {
    if (index == 0 && currentIndex != 0) {
      context.read<DashboardCubit>().refresh();
    }
    setState(() => currentIndex = index);
  }

  void _goHomeTab() => setState(() => currentIndex = 0);
  void _openDrawer() => scaffoldKey.currentState?.openDrawer();
  void _closeDrawer() {
    scaffoldKey.currentState?.closeDrawer();
  }

  static const Map<int, int> drawerToBottomNavIndex = {0: 0, 1: 1, 6: 2};

  void _onDrawerItemTap(int index) {
    final bottomNavIndex = drawerToBottomNavIndex[index];

    _closeDrawer();

    if (bottomNavIndex != null) {
      _changeIndex(bottomNavIndex);
      return;
    }

    _goHomeTab();
    _navigateFromDrawer(index);
  }

  void _navigateFromDrawer(int index) {
    if (index == addClassroomSubjectDrawerIndex) {
      MyNavigator.goTo(context, Routes.addClassroomSubject);
    } else if (index == subjectAssignmentDrawerIndex) {
      MyNavigator.goTo(context, Routes.teacherSubjectAssignmentView);
    } else if (index == classesDrawerIndex) {
      MyNavigator.goTo(context, Routes.classRoomManagement);
    } else if (index == notificationsDrawerIndex) {
      MyNavigator.goTo(context, Routes.notification);
    } else if (index == 2) {
      MyNavigator.goTo(context, Routes.teacherSubjectAssignmentView);
    } else if (index == 3) {
      MyNavigator.goTo(context, Routes.teacherApplication);
    } else if (index == 4) {
      MyNavigator.goTo(context, Routes.registrationRequests);
    } else if (index == 7) {
      MyNavigator.goTo(context, Routes.gradesManagement);
    } else if (index == 8) {
      MyNavigator.goTo(context, Routes.tablesManagement);
    } else if (index == ChatRoleNavigation.adminDrawerIndex) {
      MyNavigator.goTo(context, ChatRoleNavigation.messagesRoute);
    } else if (index == 10) {
      MyNavigator.goTo(context, Routes.notification);
    } else if (index == 11) {
      MyNavigator.goTo(context, Routes.studentClassroomAssignment);
    } else if (index == 12) {
      MyNavigator.goTo(context, Routes.curriculumManagement);
    } else if (index == 13) {
      MyNavigator.goTo(context, Routes.termPlans);
    } else if (index == 14) {
      MyNavigator.goTo(context, Routes.supervisorClassRoomAssignment);
    } else if (index == 15) {
      MyNavigator.goTo(context, Routes.discountCodes);
    } else if (index == 16) {
      MyNavigator.goTo(context, Routes.teacherPayrolls);
    } else if (index == 17) {
      MyNavigator.goTo(context, Routes.idealSupervisor);
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
              ? AdminHomeDrawer(
                  onItemTap: _onDrawerItemTap,
                  onLogoutTap: _logout,
                )
              : null,
          body: AdminHomeBody(index: currentIndex, onMenuTap: _openDrawer),
          bottomNavigationBar: AdminBottomNavBar(
            currentIndex: currentIndex,
            onTap: _changeIndex,
          ),
        ),
      ),
    );
  }
}
