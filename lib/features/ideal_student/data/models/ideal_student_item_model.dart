import 'package:bnan_app/features/ideal_student/data/models/ideal_student_json_parser.dart';

class IdealStudentItemModel {
  const IdealStudentItemModel({
    this.studentId = '',
    this.userId = '',
    this.name = '',
    this.gradeLabel = '',
    this.weeklyPoints = 0,
    this.automatedPoints = 0,
    this.bonusPoints = 0,
    this.rank = 0,
    this.isQualifiedForIdealStudent = false,
    this.opportunityCoverage = 0,
    this.isCurrentUser = false,
  });

  final String studentId, userId, name, gradeLabel;
  final num weeklyPoints, automatedPoints, bonusPoints, opportunityCoverage;
  final int rank;
  final bool isQualifiedForIdealStudent, isCurrentUser;
  num get points => weeklyPoints;

  factory IdealStudentItemModel.fromJson(Map<String, dynamic> json) {
    final student = IdealStudentJsonParser.map(json['student']);
    return IdealStudentItemModel(
      studentId: IdealStudentJsonParser.text(student['id'] ?? student['_id']),
      userId: IdealStudentJsonParser.text(student['userId']),
      name: IdealStudentJsonParser.text(student['fullName']),
      weeklyPoints: IdealStudentJsonParser.number(json['weeklyPoints']),
      automatedPoints: IdealStudentJsonParser.number(json['automatedPoints']),
      bonusPoints: IdealStudentJsonParser.number(json['bonusPoints']),
      rank: IdealStudentJsonParser.integer(json['rank']),
      isQualifiedForIdealStudent: IdealStudentJsonParser.boolean(
        json['isQualifiedForIdealStudent'],
      ),
      opportunityCoverage: IdealStudentJsonParser.number(
        json['opportunityCoverage'],
      ),
    );
  }

  IdealStudentItemModel withGradeLabel(String value) => IdealStudentItemModel(
    studentId: studentId,
    userId: userId,
    name: name,
    gradeLabel: value,
    weeklyPoints: weeklyPoints,
    automatedPoints: automatedPoints,
    bonusPoints: bonusPoints,
    rank: rank,
    isQualifiedForIdealStudent: isQualifiedForIdealStudent,
    opportunityCoverage: opportunityCoverage,
    isCurrentUser: isCurrentUser,
  );
}
