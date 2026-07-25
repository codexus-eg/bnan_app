import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/student_classroom_assignment/presentation/views/widgets/student_classroom_assignment_body.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class StudentClassroomAssignmentView extends StatelessWidget {
  const StudentClassroomAssignmentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(headerText: S.of(context).assignStudent),
      body: Padding(
        padding: const EdgeInsetsDirectional.only(start: 16, end: 16),
        child: StudentClassroomAssignmentBody(),
      ),
    );
  }
}
