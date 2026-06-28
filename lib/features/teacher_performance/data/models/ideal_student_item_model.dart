
class IdealStudentItemModel {
  const IdealStudentItemModel({
    required this.name,
    required this.gradeLabel,
    required this.points,
    required this.rank,
    required this.isCurrentUser,
  });

  final String name;
  final String gradeLabel;
  final int points;
  final int rank;
  final bool isCurrentUser;
}
