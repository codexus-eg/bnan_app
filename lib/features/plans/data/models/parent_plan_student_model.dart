import 'package:bnan_app/features/plans/data/models/plan_model_parser.dart';

class ParentPlanStudentModel {
  const ParentPlanStudentModel({this.id = '', this.fullName = '', this.avatar});

  final String id;
  final String fullName;
  final String? avatar;

  factory ParentPlanStudentModel.fromJson(Map<String, dynamic> json) {
    final avatar = PlanModelParser.string(json['avatar']).trim();
    return ParentPlanStudentModel(
      id: PlanModelParser.id(json),
      fullName: PlanModelParser.string(json['fullName']),
      avatar: avatar.isEmpty ? null : avatar,
    );
  }
}
