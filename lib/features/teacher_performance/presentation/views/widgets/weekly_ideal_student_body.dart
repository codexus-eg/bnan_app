import 'package:bnan_app/features/teacher_performance/data/models/weekly_ideal_students_dummy_data.dart';
import 'package:bnan_app/features/teacher_performance/presentation/views/widgets/ideal_students_ranked_list.dart';
import 'package:bnan_app/features/teacher_performance/presentation/views/widgets/top_ideal_student_card.dart';
import 'package:flutter/material.dart';

class WeeklyIdealStudentBody extends StatelessWidget {
  const WeeklyIdealStudentBody({super.key});

  @override
  Widget build(BuildContext context) {
    final winner = weeklyIdealStudents.first;

    return SingleChildScrollView(
      child: Column(
        children: [
          TopIdealStudentCard(student: winner),
          IdealStudentsRankedList(students: weeklyIdealStudents),
        ],
      ),
    );
  }
}
