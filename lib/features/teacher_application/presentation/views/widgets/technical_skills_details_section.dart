import 'package:bnan_app/features/teacher_application/data/models/details_field_data.dart';
import 'package:bnan_app/features/teacher_application/data/models/teacher_request_model.dart';
import 'package:bnan_app/features/teacher_application/presentation/views/widgets/details_section.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class TechnicalSkillsDetailsSection extends StatelessWidget {
  const TechnicalSkillsDetailsSection({super.key, required this.teacher});

  final TeacherRequestModel teacher;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return DetailsSection(
      title: s.teacherStepTechnicalSkills,
      fields: [
        DetailsFieldData(s.hasGoodCamera, _yesNo(s, teacher.hasGoodCamera)),
        DetailsFieldData(s.hasClearMic, _yesNo(s, teacher.hasMicrophone)),
        DetailsFieldData(
          s.hasStableInternet,
          _yesNo(s, teacher.hasStableInternet),
        ),
        DetailsFieldData(s.hasLaptopOrComputer, _yesNo(s, teacher.hasLaptop)),
        DetailsFieldData(s.technicalAppsLevel, teacher.computerSkillLevel),
      ],
    );
  }

  String _yesNo(S s, bool value) => value ? s.yes : s.no;
}