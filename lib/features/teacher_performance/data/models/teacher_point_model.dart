enum TeacherPointType { reward, deduction }

class TeacherPointModel {
  final String title;
  final String date;
  final int points;
  final TeacherPointType type;

  const TeacherPointModel({
    required this.title,
    required this.date,
    required this.points,
    required this.type,
  });

  bool get isReward => type == TeacherPointType.reward;
}