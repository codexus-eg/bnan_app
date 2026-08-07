import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/student_subjects/presentation/views/widgets/student_subjects_content.dart';
import 'package:bnan_app/features/student_subjects/presentation/views/widgets/student_subjects_search.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class StudentSubjectsBody extends StatefulWidget {
  const StudentSubjectsBody({super.key});

  @override
  State<StudentSubjectsBody> createState() => _StudentSubjectsBodyState();
}

class _StudentSubjectsBodyState extends State<StudentSubjectsBody> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomAppbar(headerText: S.of(context).schoolSubjects),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 16),
          child: StudentSubjectsSearch(
            onChanged: (value) => setState(() => query = value),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
            child: StudentSubjectsContent(query: query),
          ),
        ),
      ],
    );
  }
}
