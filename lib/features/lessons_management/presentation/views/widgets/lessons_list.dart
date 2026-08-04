import 'package:bnan_app/features/lessons_management/data/models/lesson_ui_model.dart';
import 'package:bnan_app/features/lessons_management/presentation/views/widgets/lesson_card.dart';
import 'package:flutter/material.dart';

class LessonsList extends StatelessWidget {
  const LessonsList({super.key, required this.lessons, required this.onTap});

  final List<LessonUiModel> lessons;
  final ValueChanged<LessonUiModel> onTap;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 24),
      itemCount: lessons.length,
      itemBuilder: (context, index) => LessonCard(
        lesson: lessons[index],
        onTap: () => onTap(lessons[index]),
      ),
      separatorBuilder: (context, index) => const SizedBox(height: 8),
    );
  }
}
