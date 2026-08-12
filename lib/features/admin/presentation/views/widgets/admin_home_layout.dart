import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/core/shared_widget/home_appbar.dart';
import 'package:bnan_app/features/admin/presentation/views/widgets/admin_dashboard_body.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class AdminHomeLayout extends StatelessWidget {
  const AdminHomeLayout({super.key, required this.onMenuTap});
  final VoidCallback onMenuTap;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      HomeAppBar(
        userName: SessionManager.instance.userName ?? S.of(context).admin,
        onMenuTap: onMenuTap,
        onNotificationTap: () => MyNavigator.goTo(context, Routes.notification),
      ),
      const Expanded(child: AdminDashboardBody()),
    ],
  );
}
