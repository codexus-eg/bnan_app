import 'package:bnan_app/features/teacher_application/data/models/teacher_application_details_model.dart';
import 'package:bnan_app/features/teacher_application/presentation/views/widgets/details_section.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class EvaluationDetailsSection extends StatelessWidget {
  const EvaluationDetailsSection({super.key, required this.details});

  final TeacherApplicationDetailsModel details;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return DetailsSection(
      title: s.teacherStepEvaluation,
      fields: [
        DetailsFieldData(s.shortVideoLinkOptional, details.demoVideoUrl),
        DetailsFieldData(s.canDemo, _yesNo(s, details.canDemo)),
        DetailsFieldData(s.howHandleWeakStudent, details.weakStudentApproach),
        DetailsFieldData(s.whyJoinBananAcademy, details.whyJoin),
      ],
    );
  }

  String _yesNo(S s, bool value) => value ? s.yes : s.no;
}
