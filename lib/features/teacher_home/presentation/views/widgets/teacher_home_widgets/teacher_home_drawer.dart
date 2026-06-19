import 'package:bnan_app/core/shared_widget/custom_app_drawer/custom_app_drawer.dart';
import 'package:bnan_app/features/teacher_home/presentation/views/widgets/teacher_home_widgets/teacher_drawer_items.dart';
import 'package:flutter/material.dart';

class TeacherHomeDrawer extends StatelessWidget {
  const TeacherHomeDrawer({
    super.key,
    required this.onItemTap,
    required this.onLogoutTap,
  });

  final ValueChanged<int> onItemTap;
  final VoidCallback onLogoutTap;

  @override
  Widget build(BuildContext context) {
    return CustomAppDrawer(
      userName: 'أ/ سارة عبدالله',
      userSubtitle: 'معلمة الرياضيات',
      items: teacherDrawerItems(context),
      selectedIndex: 0,
      onItemTap: onItemTap,
      onLogoutTap: onLogoutTap,
    );
  }
}