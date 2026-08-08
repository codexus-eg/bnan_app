import 'package:bnan_app/features/ideal_student/data/models/ideal_student_item_model.dart';
import 'package:bnan_app/features/ideal_student/data/models/ideal_student_json_parser.dart';
import 'package:bnan_app/features/ideal_student/data/models/ideal_student_meta_models.dart';

class IdealStudentRankingResponse {
  const IdealStudentRankingResponse({
    this.classroom = const IdealStudentClassroomModel(),
    this.status = '',
    this.scoreVersion = '',
    this.period = const IdealStudentPeriodModel(),
    this.dataQuality = const IdealStudentDataQualityModel(),
    this.idealStudent,
    this.currentStudent,
    this.ranking = const [],
    this.pagination = const IdealStudentPaginationModel(),
  });

  final IdealStudentClassroomModel classroom;
  final String status, scoreVersion;
  final IdealStudentPeriodModel period;
  final IdealStudentDataQualityModel dataQuality;
  final IdealStudentItemModel? idealStudent;
  final IdealStudentItemModel? currentStudent;
  final List<IdealStudentItemModel> ranking;
  final IdealStudentPaginationModel pagination;

  factory IdealStudentRankingResponse.fromJson(Map<String, dynamic> json) {
    final data = IdealStudentJsonParser.map(json['data']).isEmpty
        ? json
        : IdealStudentJsonParser.map(json['data']);
    final classroom = IdealStudentClassroomModel.fromJson(
      IdealStudentJsonParser.map(data['classroom']),
    );
    final ideal = IdealStudentJsonParser.map(data['idealStudent']);
    final current = IdealStudentJsonParser.map(data['currentStudent']);
    return IdealStudentRankingResponse(
      classroom: classroom,
      status: IdealStudentJsonParser.text(data['status']),
      scoreVersion: IdealStudentJsonParser.text(data['scoreVersion']),
      period: IdealStudentPeriodModel.fromJson(
        IdealStudentJsonParser.map(data['period']),
      ),
      dataQuality: IdealStudentDataQualityModel.fromJson(
        IdealStudentJsonParser.map(data['dataQuality']),
      ),
      idealStudent: ideal.isEmpty
          ? null
          : IdealStudentItemModel.fromJson(
              ideal,
            ).withGradeLabel(classroom.name),
      currentStudent: current.isEmpty
          ? null
          : IdealStudentItemModel.fromJson(current),
      ranking: IdealStudentJsonParser.maps(
        data['ranking'],
      ).map(IdealStudentItemModel.fromJson).toList(growable: false),
      pagination: IdealStudentPaginationModel.fromJson(
        IdealStudentJsonParser.map(data['pagination']),
      ),
    );
  }
}
