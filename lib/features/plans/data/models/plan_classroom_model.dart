import 'package:bnan_app/features/plans/data/models/plan_model_parser.dart';

class PlanClassroomModel {
  const PlanClassroomModel({this.id = '', this.name = ''});

  final String id;
  final String name;

  factory PlanClassroomModel.fromJson(Map<String, dynamic> json) {
    return PlanClassroomModel(
      id: PlanModelParser.id(json),
      name: PlanModelParser.string(json['name']),
    );
  }
}
