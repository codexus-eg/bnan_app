import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/auth/presentation/views/widgets/student_registration_widgets/subject_option_tile.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class RequestLessonSubjectsSection extends StatelessWidget {
  const RequestLessonSubjectsSection({
    super.key,
    required this.selectedSubjects,
    required this.onChanged,
  });

  final Set<String> selectedSubjects;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final subjects = [
      s.math,
      s.science,
      s.arabicLanguage,
      s.physics,
      s.biology,
      s.socialStudies,
      s.quran,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          s.subjects,
          style: StylesManager.styleBold14(context).copyWith(
            color: ColorManager.mainColor15,
          ),
        ),
        const SizedBox(height: 8),
        ...subjects.map(
          (subject) => SubjectOptionTile(
            title: subject,
            isSelected: selectedSubjects.contains(subject),
            onTap: () => onChanged(subject),
          ),
        ),
      ],
    );
  }
}