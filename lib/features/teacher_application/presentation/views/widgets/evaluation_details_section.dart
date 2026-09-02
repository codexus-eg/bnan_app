import 'package:bnan_app/features/teacher_application/data/models/details_field_data.dart';
import 'package:bnan_app/features/teacher_application/data/models/teacher_request_model.dart';
import 'package:bnan_app/features/teacher_application/presentation/views/widgets/details_section.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class EvaluationDetailsSection extends StatelessWidget {
  const EvaluationDetailsSection({super.key, required this.teacher});

  final TeacherRequestModel teacher;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return DetailsSection(
      title: s.teacherStepEvaluation,
      fields: [
        DetailsFieldData(s.shortVideoLinkOptional, teacher.introVideoUrl),
        DetailsFieldData(s.canDemo, _yesNo(s, teacher.canProvideDemoSession)),
        DetailsFieldData(s.howHandleWeakStudent, teacher.weakStudentHandling),
        DetailsFieldData(s.whyJoinBananAcademy, teacher.joiningReason),
      ],
    );
  }

  String _yesNo(S s, bool value) => value ? s.yes : s.no;
}
