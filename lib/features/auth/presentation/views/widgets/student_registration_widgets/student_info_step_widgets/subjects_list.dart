import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/auth/presentation/views/widgets/student_registration_widgets/subject_option_tile.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class SubjectsList extends StatefulWidget {
  const SubjectsList({super.key});

  @override
  State<SubjectsList> createState() => _SubjectsListState();
}

class _SubjectsListState extends State<SubjectsList> {
  final Set<String> selectedSubjects = {};

  void _toggleSubject(String subject) {
    setState(() {
      if (selectedSubjects.contains(subject)) {
        selectedSubjects.remove(subject);
      } else {
        selectedSubjects.add(subject);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final subjects = [
      S.of(context).math,
      S.of(context).science,
      S.of(context).arabicLanguage,
      S.of(context).physics,
      S.of(context).chemistry,
      S.of(context).socialStudies,
      S.of(context).quran,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              S.of(context).subjects,
              style: StylesManager.styleBold14(
                context,
              ).copyWith(color: ColorManager.mainColor15),
            ),

            const Text(
              '*',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...subjects.map(
          (subject) => SubjectOptionTile(
            title: subject,
            isSelected: selectedSubjects.contains(subject),
            onTap: () => _toggleSubject(subject),
          ),
        ),
      ],
    );
  }
}
