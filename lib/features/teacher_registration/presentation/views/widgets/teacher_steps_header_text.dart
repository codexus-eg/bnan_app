import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class TeacherStepsHeaderData {
  const TeacherStepsHeaderData({
    required this.title,
    required this.subtitle,
    required this.headers,
  });

  final String title;
  final String subtitle;
  final List<String> headers;
}

TeacherStepsHeaderData teacherStepsHeaderText(BuildContext context) {
  return TeacherStepsHeaderData(
    title: S.of(context).teacherApplyTitle,
    subtitle: S.of(context).teacherApplySubtitle,
    headers: [
      S.of(context).teacherStepPersonalInfo,
      S.of(context).teacherStepQualification,
      S.of(context).teacherStepExperience,
      S.of(context).teacherStepTeachingDetails,
      S.of(context).teacherStepTeachingDetails,
      S.of(context).teacherStepTechnicalSkills,
      S.of(context).teacherStepEvaluation,
      S.of(context).teacherStepAttachments,
    ],
  );
}
