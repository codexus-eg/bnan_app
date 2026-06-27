import 'package:bnan_app/features/teacher_assignment/presentation/views/teacher_asignment_view.dart';
import 'package:bnan_app/features/teacher_dues/presentation/widgets/teacher_dues_body.dart';
import 'package:bnan_app/features/teacher_groups/presentation/views/widgets/teacher_groups_body.dart';
import 'package:bnan_app/features/teacher_home/presentation/views/widgets/teacher_home_widgets/teacher_home_page.dart';
import 'package:flutter/material.dart';

class TeacherHomeContent extends StatelessWidget {
  const TeacherHomeContent({
    super.key,
    required this.index,
    required this.onMenuTap,
  });

  final int index;
  final VoidCallback onMenuTap;

  @override
  Widget build(BuildContext context) {
    final pages = [
      TeacherHomePage(onMenuTap: onMenuTap),
      TeacherGroupsBody(),
      TeacherAssignmentsView(),
      TeacherDuesBody(),
      const Center(child: Text('حسابي')),
    ];

    return pages[index];
  }
}
