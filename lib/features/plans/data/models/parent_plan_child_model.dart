import 'package:bnan_app/features/plans/data/models/plan_classroom_model.dart';
import 'package:bnan_app/features/plans/data/models/plan_model_parser.dart';

class ParentPlanChildModel {
  const ParentPlanChildModel({
    this.id = '',
    this.fullName = '',
    this.classroom,
  });

  final String id;
  final String fullName;
  final PlanClassroomModel? classroom;

  factory ParentPlanChildModel.fromJson(Map<String, dynamic> json) {
    final classroom = json['classroom'];
    return ParentPlanChildModel(
      id: PlanModelParser.id(json),
      fullName: PlanModelParser.string(json['fullName']),
      classroom: classroom is Map
          ? PlanClassroomModel.fromJson(Map<String, dynamic>.from(classroom))
          : null,
    );
  }
}
