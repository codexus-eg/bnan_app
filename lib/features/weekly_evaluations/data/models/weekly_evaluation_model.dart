class WeeklyEvaluationModel {
  const WeeklyEvaluationModel({
    required this.studentName,
    required this.classLabel,
    required this.weekStart,
    required this.previewImage,
    required this.attendance,
    required this.participation,
    required this.assignments,
    required this.behavior,
    required this.notes,
  });

  final String studentName;
  final String classLabel;
  final String weekStart;
  final String previewImage;
  final String attendance;
  final String participation;
  final String assignments;
  final String behavior;
  final String notes;
}
