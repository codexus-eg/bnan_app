import 'package:bnan_app/features/shared_profile/presentation/views/bodies/student_profile_body.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/presentation/views/widgets/assignments/assignments_body.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/presentation/views/widgets/certificates/certificates_body.dart';
import 'package:bnan_app/features/home_student/presentation/views/widgets/student_home_page/student_home_page.dart';
import 'package:bnan_app/features/student_schedule/presentation/widgets/schedule_widgets/schedule_body.dart';
import 'package:flutter/material.dart';

class HomePageContent extends StatelessWidget {
  const HomePageContent({
    super.key,
    required this.index,
    required this.onMenuTap,
    required this.userName,
  });

  final int index;
  final VoidCallback onMenuTap;
  final String userName;

  @override
  Widget build(BuildContext context) {
    final pages = [
      StudentHomePage(onMenuTap: onMenuTap, userName: userName),
      const ScheduleBody(),
      AssignmentsBody(),
      CertificatesBody(),
      StudentProfileBody(),
    ];

    return pages[index];
  }
}
