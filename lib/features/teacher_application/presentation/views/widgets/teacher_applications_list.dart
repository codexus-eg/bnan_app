import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/features/teacher_application/data/models/teacher_request_model.dart';
import 'package:bnan_app/features/teacher_application/presentation/views/widgets/teacher_application_card.dart';
import 'package:flutter/material.dart';

class TeacherApplicationsList extends StatelessWidget {
  const TeacherApplicationsList({
    super.key,
    required this.teachers,
    this.isLoading = false,
  });

  final List<TeacherRequestModel> teachers;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final reversedTeachers = teachers.reversed.toList();

    return AppSkeletonizer(
      isLoading: isLoading,
      child: ListView.separated(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 24),
        itemBuilder: (context, index) {
          return TeacherApplicationCard(
            teacher: reversedTeachers[index],
          );
        },
        separatorBuilder: (_, _) => const SizedBox(height: 16),
        itemCount: reversedTeachers.length,
      ),
    );
  }
}
