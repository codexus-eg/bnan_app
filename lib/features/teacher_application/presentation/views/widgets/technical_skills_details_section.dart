import 'package:bnan_app/features/teacher_application/data/models/teacher_application_details_model.dart';
import 'package:bnan_app/features/teacher_application/presentation/views/widgets/details_section.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class TechnicalSkillsDetailsSection extends StatelessWidget {
  const TechnicalSkillsDetailsSection({super.key, required this.details});

  final TeacherApplicationDetailsModel details;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return DetailsSection(
      title: s.teacherStepTechnicalSkills,
      fields: [
        DetailsFieldData(s.hasGoodCamera, _yesNo(s, details.hasCamera)),
        DetailsFieldData(s.hasClearMic, _yesNo(s, details.hasMic)),
        DetailsFieldData(s.hasStableInternet, _yesNo(s, details.hasInternet)),
        DetailsFieldData(s.hasLaptopOrComputer, _yesNo(s, details.hasLaptop)),
        DetailsFieldData(s.technicalAppsLevel, details.computerLevel),
      ],
    );
  }

  String _yesNo(S s, bool value) => value ? s.yes : s.no;
}
