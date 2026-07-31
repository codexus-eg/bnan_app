import 'package:bnan_app/features/plans/data/models/plan_model_parser.dart';

class PlanSubjectModel {
  const PlanSubjectModel({this.id = '', this.name = ''});

  final String id;
  final String name;

  factory PlanSubjectModel.fromJson(Map<String, dynamic> json) {
    return PlanSubjectModel(
      id: PlanModelParser.id(json),
      name: PlanModelParser.string(json['name']),
    );
  }
}
