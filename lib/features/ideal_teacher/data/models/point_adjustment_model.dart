import 'package:bnan_app/features/ideal_teacher/data/models/ideal_teacher_parser.dart';

class PointAdjustmentModel {
  const PointAdjustmentModel({
    required this.id,
    required this.teacherId,
    this.classroomId = '',
    required this.points,
    required this.category,
    required this.reason,
    this.isActive = true,
    this.createdAt,
    this.awardedByName = '',
  });

  final String id, teacherId, classroomId, category, reason, awardedByName;
  final int points;
  final bool isActive;
  final DateTime? createdAt;

  factory PointAdjustmentModel.fromJson(Map<String, dynamic> json) {
    final awarded = json['awardedBy'];
    final awardedName = awarded is Map
        ? IdealTeacherParser.text(awarded['fullName'] ?? awarded['name'])
        : IdealTeacherParser.text(awarded);

    return PointAdjustmentModel(
      id: IdealTeacherParser.text(json['id'] ?? json['_id']),
      teacherId: IdealTeacherParser.text(json['teacherId']),
      classroomId: IdealTeacherParser.text(json['classroomId']),
      points: IdealTeacherParser.integer(json['points']),
      category: IdealTeacherParser.text(json['category']),
      reason: IdealTeacherParser.text(json['reason']),
      isActive: json['isActive'] is bool ? json['isActive'] as bool : true,
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
      awardedByName: awardedName,
    );
  }
}
