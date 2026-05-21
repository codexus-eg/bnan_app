import 'package:bnan_app/features/auth/presentation/views/widgets/student_registration_widgets/subject_option_tile.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class SubjectsList extends StatelessWidget {
  const SubjectsList({super.key});

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
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(S.of(context).subjects),
        const SizedBox(height: 8),
        ...subjects.map((subject) => SubjectOptionTile(title: subject)),
      ],
    );
  }
}