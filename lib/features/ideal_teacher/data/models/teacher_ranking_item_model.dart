import 'package:bnan_app/features/ideal_teacher/data/models/component_score_model.dart';
import 'package:bnan_app/features/ideal_teacher/data/models/ideal_teacher_parser.dart';

class TeacherRankingItemModel {
  const TeacherRankingItemModel({
    required this.rank,
    required this.teacherId,
    required this.fullName,
    this.avatar = '',
    this.subjects = const [],
    this.weeklyPoints,
    this.isQualifiedForIdealTeacher = false,
    this.dataCoverage,
    this.components = const RankingComponentsModel(),
  });

  final int rank;
  final String teacherId;
  final String fullName;
  final String avatar;
  final List<String> subjects;
  final num? weeklyPoints;
  final bool isQualifiedForIdealTeacher;
  final num? dataCoverage;
  final RankingComponentsModel components;

  num get manualPoints => components.interaction.points;

  factory TeacherRankingItemModel.fromJson(Map<String, dynamic> json) {
    final teacher = IdealTeacherParser.map(json['teacher']);
    final user = IdealTeacherParser.map(teacher['user']);
    String read(String key) =>
        IdealTeacherParser.text(teacher[key] ?? user[key] ?? json[key]);

    return TeacherRankingItemModel(
      rank: IdealTeacherParser.integer(json['rank']),
      teacherId: read('id').isNotEmpty ? read('id') : read('_id'),
      fullName: read('fullName').isNotEmpty ? read('fullName') : read('name'),
      avatar: read('avatar').isNotEmpty ? read('avatar') : read('avatarUrl'),
      subjects: IdealTeacherParser.labels(
        json['subjects'] ?? teacher['subjects'],
      ),
      weeklyPoints: IdealTeacherParser.nullableNumber(json['weeklyPoints']),
      isQualifiedForIdealTeacher: IdealTeacherParser.boolean(
        json['isQualifiedForIdealTeacher'],
      ),
      dataCoverage: IdealTeacherParser.nullableNumber(json['dataCoverage']),
      components: RankingComponentsModel.fromJson(json['components']),
    );
  }
}
