import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/core/shared_widget/status_bar_widget.dart';
import 'package:bnan_app/features/home_student/presentation/views/widgets/home_body.dart';
import 'package:bnan_app/features/home_student/presentation/views/widgets/home_student_bottom_nav_bar.dart';
import 'package:bnan_app/features/home_student/presentation/views/widgets/home_student_drawer.dart';
import 'package:bnan_app/features/shared_profile/data/models/logged_user_model.dart';
import 'package:bnan_app/features/shared_profile/presentation/manager/student_profile_cubit/student_profile_cubit.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class HomeStudentScaffold extends StatefulWidget {
  const HomeStudentScaffold({super.key, required this.loggedUser});

  final LoggedUserModel loggedUser;

  @override
  State<HomeStudentScaffold> createState() => _HomeStudentScaffoldState();
}

class _HomeStudentScaffoldState extends State<HomeStudentScaffold> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  int currentIndex = 0;

  static const int requestLessonDrawerIndex = 2;
  static const int groupsDrawerIndex = 3;
  static const int plansDrawerIndex = 6;
  static const int notificationDrawerIndex = 8;
  static const int evaluationsDrawerIndex = 9;

  static const Map<int, int> drawerToBottomNavIndex = {
    0: 0,
    5: 1,
    10: 2,
    4: 3,
    11: 4,
  };

  void _changeBottomNavIndex(int index) {
    if (index == 1 && _studentScheduleRoute == null) return;
    setState(() => currentIndex = index);
  }

  String? get _studentScheduleRoute {
    final session = SessionManager.instance;
    if (session.isEgyptianStudent) return Routes.egyptianSchedulesReadOnly;
    if (session.isGulfStudent) return Routes.gulfStudentScheduleReadOnly;
    return null;
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
    final bottomNavIndex = drawerToBottomNavIndex[index];

    _closeDrawer();

    if (bottomNavIndex == 1) {
      final route = _studentScheduleRoute;
      if (route != null) MyNavigator.goTo(context, route);
      return;
    }

    if (bottomNavIndex != null) {
      _changeBottomNavIndex(bottomNavIndex);
      return;
    }

    _goHomeTab();
    _navigateFromDrawer(index);
  }

  void _navigateFromDrawer(int index) {
    if (index == requestLessonDrawerIndex) {
      MyNavigator.goTo(context, Routes.requestLesson);
    } else if (index == groupsDrawerIndex) {
      MyNavigator.goTo(context, Routes.studentGroups);
    } else if (index == plansDrawerIndex) {
      MyNavigator.goTo(
        context,
        Routes.plans,
        extra: widget.loggedUser.isGulfStudent,
      );
    } else if (index == notificationDrawerIndex) {
      MyNavigator.goTo(context, Routes.notification);
    } else if (index == evaluationsDrawerIndex) {
      MyNavigator.goTo(context, Routes.weeklyEvaluations);
    }
  }

  Future<void> _logout() async {
    await StudentProfileCubit.get(context).logout();

    if (!mounted) return;

    showCustomSnackBar(context, S.of(context).logoutSuccess, true);

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
              ? HomeStudentDrawer(
                  loggedUser: widget.loggedUser,
                  onItemTap: _onDrawerItemTap,
                  onLogoutTap: _logout,
                )
              : null,
          body: HomeStudentBody(
            index: currentIndex,
            userName: widget.loggedUser.firstTwoNames,
            onMenuTap: _openDrawer,
          ),
          bottomNavigationBar: HomeStudentBottomNavBar(
            currentIndex: currentIndex,
            onTap: _changeBottomNavIndex,
          ),
        ),
      ),
    );
  }
}
