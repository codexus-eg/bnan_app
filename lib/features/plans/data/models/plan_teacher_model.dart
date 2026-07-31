import 'package:bnan_app/features/plans/data/models/plan_model_parser.dart';

class PlanTeacherModel {
  const PlanTeacherModel({
    this.id = '',
    this.user = const PlanTeacherUserModel(),
  });

  final String id;
  final PlanTeacherUserModel user;

  factory PlanTeacherModel.fromJson(Map<String, dynamic> json) {
    return PlanTeacherModel(
      id: PlanModelParser.id(json),
      user: PlanTeacherUserModel.fromJson(PlanModelParser.map(json['user'])),
    );
  }
}

class PlanTeacherUserModel {
  const PlanTeacherUserModel({this.id = '', this.fullName = ''});

  final String id;
  final String fullName;

  factory PlanTeacherUserModel.fromJson(Map<String, dynamic> json) {
    return PlanTeacherUserModel(
      id: PlanModelParser.id(json),
      fullName: PlanModelParser.string(json['fullName']),
    );
  }
}
