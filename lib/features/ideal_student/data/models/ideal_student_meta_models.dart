import 'package:bnan_app/features/ideal_student/data/models/ideal_student_json_parser.dart';

class IdealStudentClassroomModel {
  const IdealStudentClassroomModel({this.id = '', this.name = ''});
  final String id, name;

  factory IdealStudentClassroomModel.fromJson(Map<String, dynamic> json) =>
      IdealStudentClassroomModel(
        id: IdealStudentJsonParser.text(json['id'] ?? json['_id']),
        name: IdealStudentJsonParser.text(json['name']),
      );
}

class IdealStudentPeriodModel {
  const IdealStudentPeriodModel({this.weekStart, this.weekEnd});
  final DateTime? weekStart, weekEnd;

  factory IdealStudentPeriodModel.fromJson(Map<String, dynamic> json) =>
      IdealStudentPeriodModel(
        weekStart: DateTime.tryParse(
          IdealStudentJsonParser.text(json['weekStart']),
        ),
        weekEnd: DateTime.tryParse(
          IdealStudentJsonParser.text(json['weekEnd']),
        ),
      );
}

class IdealStudentDataQualityModel {
  const IdealStudentDataQualityModel({
    this.isComplete = false,
    this.reasons = const [],
  });
  final bool isComplete;
  final List<String> reasons;

  factory IdealStudentDataQualityModel.fromJson(Map<String, dynamic> json) =>
      IdealStudentDataQualityModel(
        isComplete: IdealStudentJsonParser.boolean(json['isComplete']),
        reasons: (json['reasons'] as List? ?? const [])
            .map(IdealStudentJsonParser.text)
            .where((item) => item.isNotEmpty)
            .toList(growable: false),
      );
}

class IdealStudentPaginationModel {
  const IdealStudentPaginationModel({
    this.page = 1,
    this.limit = 20,
    this.total = 0,
    this.pages = 1,
  });
  final int page, limit, total, pages;

  factory IdealStudentPaginationModel.fromJson(Map<String, dynamic> json) =>
      IdealStudentPaginationModel(
        page: IdealStudentJsonParser.integer(json['page']).clamp(1, 1 << 31),
        limit: IdealStudentJsonParser.integer(json['limit']).clamp(1, 1 << 31),
        total: IdealStudentJsonParser.integer(json['total']),
        pages: IdealStudentJsonParser.integer(json['pages']).clamp(1, 1 << 31),
      );
}
