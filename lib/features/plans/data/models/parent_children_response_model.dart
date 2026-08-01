import 'package:bnan_app/features/plans/data/models/parent_plan_child_model.dart';
import 'package:bnan_app/features/plans/data/models/plan_model_parser.dart';

class ParentChildrenResponseModel {
  const ParentChildrenResponseModel({this.status = '', this.data = const []});

  final String status;
  final List<ParentPlanChildModel> data;

  factory ParentChildrenResponseModel.fromJson(Map<String, dynamic> json) {
    return ParentChildrenResponseModel(
      status: PlanModelParser.string(json['status']),
      data: PlanModelParser.maps(
        json['data'],
      ).map(ParentPlanChildModel.fromJson).toList(),
    );
  }
}
