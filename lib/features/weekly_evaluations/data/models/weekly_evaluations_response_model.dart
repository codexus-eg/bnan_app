import 'package:bnan_app/features/weekly_evaluations/data/models/evaluation_json_parser.dart';
import 'package:bnan_app/features/weekly_evaluations/data/models/evaluation_subject_model.dart';

class WeeklyEvaluationsResponseModel {
  const WeeklyEvaluationsResponseModel({
    this.success = false,
    this.results = 0,
    required this.data,
  });

  final bool success;
  final int results;
  final WeeklyEvaluationsDataModel data;

  factory WeeklyEvaluationsResponseModel.fromJson(Map<String, dynamic> json) =>
      WeeklyEvaluationsResponseModel(
        success: EvaluationJsonParser.boolean(json['success']),
        results: EvaluationJsonParser.integer(json['results']),
        data: WeeklyEvaluationsDataModel.fromJson(
          EvaluationJsonParser.map(json['data']),
        ),
      );
}

class WeeklyEvaluationsDataModel {
  const WeeklyEvaluationsDataModel({
    this.classroomId = '',
    this.classroomName = '',
    this.week = 0,
    this.weekStart = '',
    this.students = const [],
  });

  final String classroomId, classroomName, weekStart;
  final int week;
  final List<WeeklyEvaluationStudentModel> students;

  factory WeeklyEvaluationsDataModel.fromJson(Map<String, dynamic> json) {
    final classroom = EvaluationJsonParser.map(json['classroom']);
    var students = EvaluationJsonParser.maps(json['students']);
    if (students.isEmpty) {
      final student = EvaluationJsonParser.map(json['student']);
      if (student.isNotEmpty) {
        students = [
          {
            ...student,
            if (!student.containsKey('subjects')) 'subjects': json['subjects'],
          },
        ];
      } else if (json['subjects'] is List &&
          (json.containsKey('id') || json.containsKey('fullName'))) {
        students = [json];
      }
    }
    return WeeklyEvaluationsDataModel(
      classroomId: EvaluationJsonParser.id(classroom),
      classroomName: EvaluationJsonParser.string(classroom['name']),
      week: EvaluationJsonParser.integer(json['week']),
      weekStart: EvaluationJsonParser.string(json['weekStart']),
      students: students.map(WeeklyEvaluationStudentModel.fromJson).toList(),
    );
  }
}

class WeeklyEvaluationStudentModel {
  const WeeklyEvaluationStudentModel({
    this.id = '',
    this.fullName = '',
    this.avatar = '',
    this.subjects = const [],
  });

  final String id, fullName, avatar;
  final List<EvaluationSubjectModel> subjects;

  factory WeeklyEvaluationStudentModel.fromJson(Map<String, dynamic> json) =>
      WeeklyEvaluationStudentModel(
        id: EvaluationJsonParser.id(json),
        fullName: EvaluationJsonParser.string(json['fullName'] ?? json['name']),
        avatar: EvaluationJsonParser.string(json['avatar']),
        subjects: EvaluationJsonParser.maps(
          json['subjects'],
        ).map(EvaluationSubjectModel.fromJson).toList(),
      );
}
