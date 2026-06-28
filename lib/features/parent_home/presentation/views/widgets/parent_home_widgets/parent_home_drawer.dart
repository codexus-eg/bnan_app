import 'package:bnan_app/core/shared_widget/custom_app_drawer/custom_app_drawer.dart';
import 'package:bnan_app/features/parent_home/presentation/views/widgets/parent_home_widgets/parent_drawer_items.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ParentHomeDrawer extends StatelessWidget {
  const ParentHomeDrawer({
    super.key,
    required this.onItemTap,
    required this.onLogoutTap,
  });

  final ValueChanged<int> onItemTap;
  final VoidCallback onLogoutTap;

  @override
  Widget build(BuildContext context) {
    return CustomAppDrawer(
      userName: 'أ/ خالد عبدالله',
      userSubtitle: S.of(context).parentGuardian,
      items: parentDrawerItems(context),
      selectedIndex: 0,
      onItemTap: onItemTap,
      onLogoutTap: onLogoutTap,
    );
  }
}
