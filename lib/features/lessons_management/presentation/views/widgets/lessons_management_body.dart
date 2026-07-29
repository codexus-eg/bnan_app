import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/features/lessons_management/data/lessons_mock_data.dart';
import 'package:bnan_app/features/lessons_management/data/models/lesson_ui_model.dart';
import 'package:bnan_app/features/lessons_management/presentation/views/widgets/dialogs/add_lesson_dialog.dart';
import 'package:bnan_app/features/lessons_management/presentation/views/widgets/lessons_list.dart';
import 'package:bnan_app/features/lessons_management/presentation/views/widgets/lessons_management_header.dart';
import 'package:bnan_app/features/lessons_management/presentation/views/widgets/lessons_selected_date_header.dart';
import 'package:bnan_app/features/lessons_management/presentation/views/widgets/lessons_week_days_selector.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class LessonsManagementBody extends StatelessWidget {
  const LessonsManagementBody({super.key});

  @override
  Widget build(BuildContext context) {
    const showEmptyPreview = false;
    final lessons = showEmptyPreview
        ? const <LessonUiModel>[]
        : lessonsMockData;

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          LessonsManagementHeader(
            onAddTap: () => showDialog<void>(
              context: context,
              builder: (_) => const AddLessonDialog(),
            ),
          ),
          const SizedBox(height: 16),
          const LessonsWeekDaysSelector(),
          const SizedBox(height: 16),
          const LessonsSelectedDateHeader(),
          const SizedBox(height: 16),
          Expanded(
            child: lessons.isEmpty
                ? NoDataWidget(title: S.of(context).noLessonsForSelectedDay)
                : LessonsList(lessons: lessons),
          ),
        ],
      ),
    );
  }
}
