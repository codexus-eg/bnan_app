import 'package:bnan_app/features/plans/data/models/parent_plan_student_model.dart';
import 'package:bnan_app/features/plans/data/models/plan_classroom_model.dart';
import 'package:bnan_app/features/plans/data/models/plan_model_parser.dart';
import 'package:bnan_app/features/plans/data/models/weekly_plans_response_model.dart';

class ParentChildPlansModel {
  const ParentChildPlansModel({
    this.student = const ParentPlanStudentModel(),
    this.week = 0,
    this.classrooms = const [],
    this.subjects = const [],
  });

  final ParentPlanStudentModel student;
  final int week;
  final List<PlanClassroomModel> classrooms;
  final List<WeeklyPlanSubjectModel> subjects;

  factory ParentChildPlansModel.fromJson(Map<String, dynamic> json) {
    return ParentChildPlansModel(
      student: ParentPlanStudentModel.fromJson(
        PlanModelParser.map(json['student']),
      ),
      week: PlanModelParser.integer(json['week']),
      classrooms: PlanModelParser.maps(
        json['classrooms'],
      ).map(PlanClassroomModel.fromJson).toList(),
      subjects: PlanModelParser.maps(
        json['subjects'],
      ).map(WeeklyPlanSubjectModel.fromJson).toList(),
    );
  }
}
