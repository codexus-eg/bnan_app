class WeeklyEvaluationSubjectUiModel {
  const WeeklyEvaluationSubjectUiModel({
    this.id = '',
    required this.subjectName,
    required this.attendance,
    required this.participation,
    required this.homework,
    required this.behavior,
    required this.notes,
    this.isEvaluated = true,
  });

  final String id;
  final String subjectName;
  final String attendance;
  final String participation;
  final String homework;
  final String behavior;
  final String notes;
  final bool isEvaluated;
}
