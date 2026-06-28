import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/shared_widget/home_appbar.dart';
import 'package:bnan_app/features/parent_home/presentation/views/widgets/parent_home_widgets/parent_children_section.dart';
import 'package:bnan_app/features/parent_home/presentation/views/widgets/parent_home_widgets/parent_home_stats_section.dart';
import 'package:bnan_app/features/parent_home/presentation/views/widgets/parent_home_widgets/parent_subscription_alert_card.dart';
import 'package:flutter/material.dart';

class ParentHomePage extends StatelessWidget {
  const ParentHomePage({super.key, required this.onMenuTap});

  final VoidCallback onMenuTap;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          HomeAppBar(
            userName: 'Salma Ehab',
            onMenuTap: onMenuTap,
            onNotificationTap: () {
              MyNavigator.goTo(context, Routes.notification);
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 24),
              child: Column(
                children: const [
                  ParentHomeStatsSection(),
                  SizedBox(height: 16),
                  ParentSubscriptionAlertCard(),
                  SizedBox(height: 16),
                  ParentChildrenSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
