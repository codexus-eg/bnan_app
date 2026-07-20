import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/features/student_groups/presentation/views/widgets/request_lesson/request_lesson_subjects_section.dart.dart';
import 'package:bnan_app/features/student_groups/presentation/views/widgets/shared_widgets/shared_group_header.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class RequestLessonBody extends StatefulWidget {
  const RequestLessonBody({super.key});

  @override
  State<RequestLessonBody> createState() => _RequestLessonBodyState();
}

class _RequestLessonBodyState extends State<RequestLessonBody> {
  String selectedGrade = '';
  String selectedCurriculum = '';
  final Set<String> selectedSubjects = {};

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final grades = [s.chooseGrade, s.primaryGradeFive];
    final curriculums = [s.chooseNewCurriculum, s.saudiCurriculum];

    selectedGrade = selectedGrade.isEmpty ? grades.first : selectedGrade;
    selectedCurriculum = selectedCurriculum.isEmpty
        ? curriculums.first
        : selectedCurriculum;

    return Column(
      children: [
        SharedGroupHeader(
          title: S.of(context).requestNewLesson,
          path: Routes.studentGroups,
          badgeTitle: S.of(context).myRequests,
          isIcon: false,
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
            children: [
              RequestLessonSubjectsSection(
                selectedSubjects: selectedSubjects,
                onChanged: (subject) {
                  setState(() {
                    selectedSubjects.contains(subject)
                        ? selectedSubjects.remove(subject)
                        : selectedSubjects.add(subject);
                  });
                },
              ),
              const SizedBox(height: 16),
              CustomDropdown(
                label: s.grade,
                value: selectedGrade,
                items: grades,
                onChanged: (value) {
                  if (value != null) setState(() => selectedGrade = value);
                },
              ),
              const SizedBox(height: 16),
              CustomDropdown(
                label: s.saudiCurriculum,
                value: selectedCurriculum,
                items: curriculums,
                onChanged: (value) {
                  if (value != null) {
                    setState(() => selectedCurriculum = value);
                  }
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: s.theRequiredLesson,
                hintText: s.studentNotesExample,
                maxLine: 4,
              ),
              const SizedBox(height: 20),
              CustomAppButton(text: s.confirmRequest, onPressed: () {}),
            ],
          ),
        ),
      ],
    );
  }
}
