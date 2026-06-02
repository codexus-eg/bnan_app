import 'package:bnan_app/features/assignments_and_certificate/presentation/views/widgets/assignments/assignments_body.dart';
import 'package:bnan_app/features/assignments_and_certificate/presentation/views/widgets/certificates/certificates_body.dart';
import 'package:bnan_app/features/home_student/presentation/views/widgets/student_home_page/student_home_page.dart';
import 'package:bnan_app/features/schedule/presentation/views/widgets/schedule_widgets/schedule_body.dart';
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
      ScheduleBody(),
      AssignmentsBody(),
      CertificatesBody(),
      Center(child: Text(S.of(context).myAccount)),
    ];

    return pages[index];
  }
}