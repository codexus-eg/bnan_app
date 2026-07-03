import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/teacher_application/presentation/views/widgets/teacher_application_body.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class TeacherApplicationView extends StatelessWidget {
  const TeacherApplicationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(headerText: S.of(context).teacherApplications),
      body: TeacherApplicationBody(),
    );
  }
}
