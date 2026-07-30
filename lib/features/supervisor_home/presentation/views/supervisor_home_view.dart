import 'package:bnan_app/core/helper/app_logout.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/supervisor_home/presentation/config/supervisor_navigation_config.dart';
import 'package:bnan_app/features/supervisor_home/presentation/models/supervisor_home_ui_data.dart';
import 'package:bnan_app/features/supervisor_home/presentation/models/supervisor_navigation_item.dart';
import 'package:bnan_app/features/supervisor_home/presentation/views/widgets/supervisor_home_scaffold.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class SupervisorHomeView extends StatefulWidget {
  const SupervisorHomeView({super.key, this.userName});

  final String? userName;

  @override
  State<SupervisorHomeView> createState() => SupervisorHomeViewState();
}

class SupervisorHomeViewState extends State<SupervisorHomeView> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoggingOut = false;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final drawerItems = SupervisorNavigationConfig.drawer(s);
    final bottomItems = SupervisorNavigationConfig.bottom(s);
    final userName =
        widget.userName?.trim() ?? SessionManager.instance.userName?.trim();
    final effectiveName = userName?.isNotEmpty == true
        ? userName!
        : s.supervisor;
    return SupervisorHomeScaffold(
      scaffoldKey: scaffoldKey,
      userName: effectiveName,
      userSubtitle: s.supervisor,
      data: SupervisorHomeUiData.mock(s),
      drawerItems: drawerItems,
      bottomItems: bottomItems,
      onDrawerTap: (index) => navigate(drawerItems[index], closeDrawer: true),
      onBottomTap: (index) => navigate(bottomItems[index]),
      onLogoutTap: logout,
    );
  }

  void navigate(SupervisorNavigationItem item, {bool closeDrawer = false}) {
    if (closeDrawer) scaffoldKey.currentState?.closeDrawer();
    if (!item.isEnabled) return;
    MyNavigator.goTo(context, item.route!, extra: item.extra);
  }

  Future<void> logout() async {
    if (isLoggingOut) return;
    isLoggingOut = true;
    await AppLogout.perform(context);
    if (mounted) isLoggingOut = false;
  }
}
