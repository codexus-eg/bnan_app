import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/teacher_performance/presentation/views/widgets/weekly_ideal_student_body.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class WeeklyIdealStudentView extends StatelessWidget {
  const WeeklyIdealStudentView({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: CustomAppbar(headerText: S.of(context).weeklyIdealStudent),
      body: WeeklyIdealStudentBody(),
    );
  }
}
