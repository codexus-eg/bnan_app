import 'package:bnan_app/features/lessons_management/presentation/views/widgets/add_lesson_button.dart';
import 'package:flutter/material.dart';

class LessonsManagementHeader extends StatelessWidget {
  const LessonsManagementHeader({super.key, required this.onAddTap});

  final VoidCallback onAddTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [AddLessonButton(onTap: onAddTap)],
      ),
    );
  }
}
