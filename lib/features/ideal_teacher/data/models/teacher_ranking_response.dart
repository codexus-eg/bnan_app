import 'package:bnan_app/features/dashboard/data/models/points_period_model.dart';
import 'package:bnan_app/features/ideal_teacher/data/models/ideal_teacher_parser.dart';
import 'package:bnan_app/features/ideal_teacher/data/models/teacher_ranking_item_model.dart';

class TeacherRankingResponse {
  const TeacherRankingResponse({
    this.classroomId = '',
    this.classroomName = '',
    this.period = const PointsPeriodModel(),
    this.scoreVersion = '',
    this.status = '',
    this.idealTeacher,
    this.ranking = const [],
    this.total = 0,
    this.page = 1,
    this.limit = 20,
    this.pages = 1,
  });

  final String classroomId, classroomName, scoreVersion, status;
  final PointsPeriodModel period;
  final TeacherRankingItemModel? idealTeacher;
  final List<TeacherRankingItemModel> ranking;
  final int total, page, limit, pages;

  bool get isProvisional => status.toLowerCase() == 'provisional';
  bool get isInsufficientData => status.toLowerCase() == 'insufficient_data';
  bool get hasQualifiedWinner => !isInsufficientData && idealTeacher != null;

  factory TeacherRankingResponse.fromJson(Map<String, dynamic> json) {
    final data = IdealTeacherParser.map(json['data']).isEmpty
        ? json
        : IdealTeacherParser.map(json['data']);
    final classroom = IdealTeacherParser.map(data['classroom']);
    final pagination = IdealTeacherParser.map(data['pagination']);
    final ideal = IdealTeacherParser.map(data['idealTeacher']);

    return TeacherRankingResponse(
      classroomId: IdealTeacherParser.text(classroom['id'] ?? classroom['_id']),
      classroomName: IdealTeacherParser.text(classroom['name']),
      period: PointsPeriodModel.fromJson(
        IdealTeacherParser.map(data['period']),
      ),
      scoreVersion: IdealTeacherParser.text(data['scoreVersion']),
      status: IdealTeacherParser.text(data['status']),
      idealTeacher:
          ideal.isEmpty ? null : TeacherRankingItemModel.fromJson(ideal),
      ranking: IdealTeacherParser.maps(
        data['ranking'],
      ).map(TeacherRankingItemModel.fromJson).toList(growable: false),
      total: IdealTeacherParser.integer(pagination['total']),
      page: IdealTeacherParser.integer(pagination['page']),
      limit: IdealTeacherParser.integer(pagination['limit']),
      pages: IdealTeacherParser.integer(pagination['pages']),
    );
  }
}
