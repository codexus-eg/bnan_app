import 'package:bnan_app/features/teacher_application/data/models/details_field_data.dart';
import 'package:bnan_app/features/teacher_application/data/models/teacher_request_model.dart';
import 'package:bnan_app/features/teacher_application/presentation/views/widgets/details_section.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class BnanTeachingDetailsSection extends StatelessWidget {
  const BnanTeachingDetailsSection({super.key, required this.teacher});

  final TeacherRequestModel teacher;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return DetailsSection(
      title: s.teachingInBnan,
      fields: [
        DetailsFieldData(
          s.weeklyHours,
          teacher.availableHoursPerWeek.toString(),
        ),
        DetailsFieldData(
          s.curriculum,
          teacher.curriculums.map((e) => e.name).join('، '),
        ),
        DetailsFieldData(s.desiredSubjects, '-'),
        DetailsFieldData(s.availability, _yesNo(s, teacher.isAvailable)),
        DetailsFieldData(s.teachableGrades, '-'),
      ],
    );
  }

  String _yesNo(S s, bool value) => value ? s.yes : s.no;
}