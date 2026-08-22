import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/app_logout.dart';
import 'package:bnan_app/core/helper/drawer_navigation_guard.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/core/session/current_user_ui.dart';
import 'package:bnan_app/core/shared_widget/status_bar_widget.dart';
import 'package:bnan_app/features/home_student/presentation/views/widgets/home_body.dart';
import 'package:bnan_app/features/home_student/presentation/views/widgets/home_student_bottom_nav_bar.dart';
import 'package:bnan_app/features/home_student/presentation/views/widgets/home_student_drawer.dart';
import 'package:bnan_app/features/chats/presentation/navigation/chat_role_navigation.dart';
import 'package:bnan_app/features/shared_profile/data/models/logged_user_model.dart';
import 'package:bnan_app/features/shared_profile/presentation/manager/student_profile_cubit/student_profile_cubit.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bnan_app/features/dashboard/presentation/manager/dashboard_cubit.dart';

class HomeStudentScaffold extends StatefulWidget {
  const HomeStudentScaffold({super.key, required this.loggedUser});

  final LoggedUserModel loggedUser;

  @override
  State<HomeStudentScaffold> createState() => _HomeStudentScaffoldState();
}

class _HomeStudentScaffoldState extends State<HomeStudentScaffold> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _drawerNavigation = DrawerNavigationGuard();

  int currentIndex = 0;
  int _tabRevision = 0;
  bool _isNavigating = false;

  static const int requestLessonDrawerIndex = 2;
  static const int subjectsDrawerIndex = 1;
  static const int plansDrawerIndex = 5;
  static const int notificationDrawerIndex = 7;
  static const int evaluationsDrawerIndex = 8;
  static const int subscriptionsDrawerIndex = 6;

  static const Map<int, int> drawerToBottomNavIndex = {
    0: 0,
    4: 1,
    9: 2,
    ChatRoleNavigation.studentDrawerIndex: 3,
    10: 4,
  };

  void _changeBottomNavIndex(int index) {
    if (index == 1 && _studentScheduleRoute == null) return;
    if (index == currentIndex) return;
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

  String? get _studentScheduleRoute {
    final session = SessionManager.instance;
    if (session.isEgyptianStudent) return Routes.egyptianSchedulesReadOnly;
    if (session.isGulfStudent) return Routes.gulfStudentScheduleReadOnly;
    return null;
  }

  void _goHomeTab() {
    if (currentIndex != 0) _changeBottomNavIndex(0);
  }

  void _openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  void _closeDrawer() {
    scaffoldKey.currentState?.closeDrawer();
  }

  Future<void> _onDrawerItemTap(int index) async {
    if (_isNavigating || !_drawerNavigation.begin()) return;
    final bottomNavIndex = drawerToBottomNavIndex[index];

    _closeDrawer();

    if (bottomNavIndex != null) {
      _changeBottomNavIndex(bottomNavIndex);
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
    if (index == subjectsDrawerIndex) {
      await MyNavigator.goTo(context, Routes.studentSubjects);
    } else if (index == requestLessonDrawerIndex) {
      await MyNavigator.goTo(context, Routes.requestLesson);
    } else if (index == 3) {
      await MyNavigator.goTo(context, Routes.parentCertificates);
    } else if (index == plansDrawerIndex) {
      await MyNavigator.goTo(
        context,
        Routes.plans,
        extra: SessionManager.instance.isGulfStudent,
      );
    } else if (index == notificationDrawerIndex) {
      await MyNavigator.goTo(context, Routes.notification);
    } else if (index == evaluationsDrawerIndex) {
      await MyNavigator.goTo(context, Routes.weeklyEvaluations);
    } else if (index == subscriptionsDrawerIndex) {
      await MyNavigator.goTo(context, Routes.studentSubscriptions);
    }
  }

  Future<void> _logout() async {
    await StudentProfileCubit.get(context).logout();
    final destination = await AppLogout.destinationAfterLogout();

    if (!mounted) return;

    showCustomSnackBar(context, S.of(context).logoutSuccess, true);

    MyNavigator.goToOffAll(context, destination);
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
          onDrawerChanged: _drawerNavigation.drawerChanged,
          drawer: currentIndex == 0
              ? HomeStudentDrawer(
                  loggedUser: widget.loggedUser,
                  onItemTap: _onDrawerItemTap,
                  onLogoutTap: _logout,
                )
              : null,
          body: HomeStudentBody(
            key: ValueKey('$currentIndex:$_tabRevision'),
            index: currentIndex,
            userName: CurrentUserUi.name(context),
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
