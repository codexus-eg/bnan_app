import 'package:bnan_app/features/home_student/features/views/widgets/student_home_page/student_home_page.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class HomePageContent extends StatelessWidget {
  const HomePageContent({super.key, required this.index, required this.onMenuTap});

  final int index;
  final VoidCallback onMenuTap;

  @override
  Widget build(BuildContext context) {
    final pages = [
      StudentHomePage(onMenuTap: onMenuTap),
      Center(child: Text(S.of(context).schedule)),
      Center(child: Text(S.of(context).assignments)),
      Center(child: Text(S.of(context).services)),
      Center(child: Text(S.of(context).myAccount)),
    ];

    return pages[index];
  }
}