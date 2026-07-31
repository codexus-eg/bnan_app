import 'package:bnan_app/features/plans/data/models/plan_model_parser.dart';
import 'package:bnan_app/features/plans/data/models/plan_subject_model.dart';
import 'package:bnan_app/features/plans/data/models/plan_teacher_model.dart';

class CreatePlanResponseModel {
  const CreatePlanResponseModel({
    this.success = false,
    this.data = const CreatePlanDataModel(),
  });

  final bool success;
  final CreatePlanDataModel data;

  factory CreatePlanResponseModel.fromJson(Map<String, dynamic> json) {
    return CreatePlanResponseModel(
      success: PlanModelParser.boolean(json['success']),
      data: CreatePlanDataModel.fromJson(PlanModelParser.map(json['data'])),
    );
  }
}

class CreatePlanDataModel {
  const CreatePlanDataModel({
    this.classroomSubject = '',
    this.subject = const PlanSubjectModel(),
    this.teacher = const PlanTeacherModel(),
    this.type = '',
    this.attachment = '',
    this.week = 0,
    this.day = '',
    this.sessionContent = '',
    this.sessionAssignment = '',
    this.createdAt = '',
    this.updatedAt = '',
    this.id = '',
  });

  final String classroomSubject;
  final PlanSubjectModel subject;
  final PlanTeacherModel teacher;
  final String type;
  final String attachment;
  final int week;
  final String day;
  final String sessionContent;
  final String sessionAssignment;
  final String createdAt;
  final String updatedAt;
  final String id;

  factory CreatePlanDataModel.fromJson(Map<String, dynamic> json) {
    return CreatePlanDataModel(
      classroomSubject: PlanModelParser.string(json['classroomSubject']),
      subject: PlanSubjectModel.fromJson(PlanModelParser.map(json['subject'])),
      teacher: PlanTeacherModel.fromJson(PlanModelParser.map(json['teacher'])),
      type: PlanModelParser.string(json['type']),
      attachment: PlanModelParser.string(json['attachment']),
      week: PlanModelParser.integer(json['week']),
      day: PlanModelParser.string(json['day']),
      sessionContent: PlanModelParser.string(json['sessionContent']),
      sessionAssignment: PlanModelParser.string(json['sessionAssignment']),
      createdAt: PlanModelParser.string(json['createdAt']),
      updatedAt: PlanModelParser.string(json['updatedAt']),
      id: PlanModelParser.id(json),
    );
  }
}
