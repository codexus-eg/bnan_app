import 'package:bnan_app/features/home_student/features/views/widgets/home_page_content.dart';
import 'package:flutter/material.dart';

class HomeStudentBody extends StatelessWidget {
  const HomeStudentBody({
    super.key,
    required this.index,
    required this.onMenuTap,
  });

  final int index;
  final VoidCallback onMenuTap;

  @override
  Widget build(BuildContext context) {
    return HomePageContent(index: index, onMenuTap: onMenuTap);
  }
}
