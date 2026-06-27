import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/teacher_performance/presentation/views/widgets/teacher_performance_body.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class TeacherPerformanceView extends StatelessWidget {
  const TeacherPerformanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: CustomAppbar(headerText: S.of(context).myPerformance,),
      body: TeacherPerformanceBody());
  }
}
