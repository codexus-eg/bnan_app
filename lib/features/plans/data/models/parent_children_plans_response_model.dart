import 'package:bnan_app/features/plans/data/models/parent_child_plans_model.dart';
import 'package:bnan_app/features/plans/data/models/plan_model_parser.dart';

class ParentChildrenPlansResponseModel {
  const ParentChildrenPlansResponseModel({
    this.success = false,
    this.results = 0,
    this.data = const [],
  });

  final bool success;
  final int results;
  final List<ParentChildPlansModel> data;

  factory ParentChildrenPlansResponseModel.fromJson(Map<String, dynamic> json) {
    return ParentChildrenPlansResponseModel(
      success: PlanModelParser.boolean(json['success']),
      results: PlanModelParser.integer(json['results']),
      data: PlanModelParser.maps(
        json['data'],
      ).map(ParentChildPlansModel.fromJson).toList(),
    );
  }
}
