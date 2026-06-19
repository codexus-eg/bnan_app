import 'package:bnan_app/features/teacher_home/presentation/views/widgets/teacher_home_widgets/teacher_home_content.dart';
import 'package:flutter/material.dart';

class TeacherHomeBody extends StatelessWidget {
  const TeacherHomeBody({
    super.key,
    required this.index,
    required this.onMenuTap,
  });

  final int index;
  final VoidCallback onMenuTap;

  @override
  Widget build(BuildContext context) {
    return TeacherHomeContent(
      index: index,
      onMenuTap: onMenuTap,
    );
  }
}