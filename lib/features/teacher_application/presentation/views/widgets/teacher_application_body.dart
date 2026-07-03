import 'package:bnan_app/features/teacher_application/data/models/teacher_application_model.dart';
import 'package:bnan_app/features/teacher_application/presentation/views/widgets/teacher_application_card.dart';
import 'package:flutter/material.dart';

class TeacherApplicationBody extends StatelessWidget {
  const TeacherApplicationBody({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 24),
      itemBuilder: (context, index) {
        return TeacherApplicationCard(
          teacher: teacherApplicationsMockData[index],
        );
      },
      separatorBuilder: (_, _) => const SizedBox(height: 16),
      itemCount: teacherApplicationsMockData.length,
    );
  }
}
