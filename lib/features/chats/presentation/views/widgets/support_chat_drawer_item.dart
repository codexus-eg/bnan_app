import 'package:bnan_app/core/enums/user_role.dart';
import 'package:bnan_app/core/shared_widget/custom_app_drawer/custom_app_drawer_item.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/features/chats/presentation/widgets/support_chat_launcher.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

bool supportsSupportChat(UserRole? role) => const {
  UserRole.student,
  UserRole.parent,
  UserRole.teacher,
  UserRole.supervisor,
}.contains(role);

class SupportChatDrawerItem extends StatelessWidget {
  const SupportChatDrawerItem({super.key});

  static Widget? forRole(UserRole? role) =>
      supportsSupportChat(role) ? const SupportChatDrawerItem() : null;

  @override
  Widget build(BuildContext context) => CustomAppDrawerItem(
    title: S.of(context).contactUs,
    icon: ImageManager.chatIcon,
    isSelected: false,
    onTap: () => SupportChatLauncher.open(context),
  );
}
