import 'package:bnan_app/core/shared_widget/custom_app_drawer/custom_app_drawer.dart';
import 'package:bnan_app/core/session/current_user_ui.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/support_chat_drawer_item.dart';
import 'package:bnan_app/features/parent_home/presentation/views/widgets/parent_home_widgets/parent_drawer_items.dart';
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
      userName: CurrentUserUi.name(context),
      userSubtitle: CurrentUserUi.role(context),
      items: parentDrawerItems(context),
      selectedIndex: 0,
      onItemTap: onItemTap,
      onLogoutTap: onLogoutTap,
      footer: SupportChatDrawerItem.forRole(SessionManager.instance.role),
    );
  }
}
