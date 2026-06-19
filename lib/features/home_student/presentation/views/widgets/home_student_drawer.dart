import 'package:bnan_app/core/shared_widget/custom_app_drawer/custom_app_drawer.dart';
import 'package:bnan_app/features/home_student/presentation/views/widgets/student_home_page/student_drawer_items.dart';
import 'package:bnan_app/features/student_profile/data/models/logged_user_model.dart';
import 'package:flutter/material.dart';

class HomeStudentDrawer extends StatelessWidget {
  const HomeStudentDrawer({
    super.key,
    required this.loggedUser,
    required this.onItemTap,
    required this.onLogoutTap,
  });

  final LoggedUserModel loggedUser;
  final ValueChanged<int> onItemTap;
  final VoidCallback onLogoutTap;

  @override
  Widget build(BuildContext context) {
    return CustomAppDrawer(
      userName: loggedUser.firstTwoNames,
      userSubtitle: loggedUser.gradeName,
      items: studentDrawerItems(context),
      selectedIndex: 0,
      onItemTap: onItemTap,
      onLogoutTap: onLogoutTap,
    );
  }
}