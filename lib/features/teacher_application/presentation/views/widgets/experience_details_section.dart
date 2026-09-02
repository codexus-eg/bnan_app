import 'package:bnan_app/features/teacher_application/data/models/details_field_data.dart';
import 'package:bnan_app/features/teacher_application/data/models/teacher_request_model.dart';
import 'package:bnan_app/features/teacher_application/presentation/views/widgets/details_section.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ExperienceDetailsSection extends StatelessWidget {
  const ExperienceDetailsSection({super.key, required this.teacher});

  final TeacherRequestModel teacher;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return DetailsSection(
      title: s.teacherStepExperience,
      fields: [
        DetailsFieldData(
          s.taughtOnlineBefore,
          _yesNo(s, teacher.hasOnlineTeachingExperience),
        ),
        DetailsFieldData(s.gradeLevel, '-'),
        DetailsFieldData(s.platformsUsed, '-'),
        DetailsFieldData(
          s.hasTeachingExperience,
          _yesNo(s, teacher.hasTeachingExperience),
        ),
        DetailsFieldData(s.taughtSubjects, '-'),
      ],
    );
  }

  String _yesNo(S s, bool value) => value ? s.yes : s.no;
}
