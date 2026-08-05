import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/evaluation_mode.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/gulf_evaluation_classroom_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/me_evaluation_subject_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/read_evaluation_json_parser.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/read_evaluation_reference_model.dart';

class MeWeeklyEvaluationsDataModel {
  const MeWeeklyEvaluationsDataModel({
    this.student,
    this.mode = EvaluationMode.unknown,
    this.classroomsCount = 0,
    this.week,
    this.weekStart,
    this.classroom,
    this.classrooms = const [],
    this.grade,
    this.curriculum,
    this.subjects = const [],
  });

  final ReadEvaluationReferenceModel? student, classroom, grade, curriculum;
  final EvaluationMode mode;
  final int classroomsCount;
  final int? week;
  final String? weekStart;
  final List<GulfEvaluationClassroomModel> classrooms;
  final List<MeEvaluationSubjectModel> subjects;

  factory MeWeeklyEvaluationsDataModel.fromJson(Map<String, dynamic> json) {
    final classrooms = ReadEvaluationJsonParser.maps(
      json['classrooms'],
    ).map(GulfEvaluationClassroomModel.fromJson).toList(growable: false);
    return MeWeeklyEvaluationsDataModel(
      student: ReadEvaluationReferenceModel.fromNullable(json['student']),
      mode: EvaluationMode.parse(json['mode']),
      classroomsCount:
          ReadEvaluationJsonParser.integer(json['classroomsCount']) ??
          classrooms.length,
      week: ReadEvaluationJsonParser.integer(json['week']),
      weekStart: ReadEvaluationJsonParser.nullableString(json['weekStart']),
      classroom: ReadEvaluationReferenceModel.fromNullable(json['classroom']),
      classrooms: classrooms,
      grade: ReadEvaluationReferenceModel.fromNullable(json['grade']),
      curriculum: ReadEvaluationReferenceModel.fromNullable(json['curriculum']),
      subjects: ReadEvaluationJsonParser.maps(
        json['subjects'],
      ).map(MeEvaluationSubjectModel.fromJson).toList(growable: false),
    );
  }
}
