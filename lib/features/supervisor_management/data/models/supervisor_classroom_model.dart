import 'package:bnan_app/features/supervisor_management/data/models/supervisor_classroom_lookup_model.dart';

class SupervisorClassroomModel {
  const SupervisorClassroomModel({
    this.id = '',
    this.name = '',
    this.grade = const SupervisorClassroomLookupModel(),
    this.curriculum = const SupervisorClassroomLookupModel(),
  });

  final String id;
  final String name;
  final SupervisorClassroomLookupModel grade;
  final SupervisorClassroomLookupModel curriculum;

  factory SupervisorClassroomModel.fromJson(Map<String, dynamic> json) {
    return SupervisorClassroomModel(
      id: (json['id'] ?? json['_id'])?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      grade: SupervisorClassroomLookupModel.fromJson(_map(json['grade'])),
      curriculum: SupervisorClassroomLookupModel.fromJson(
        _map(json['curriculum']),
      ),
    );
  }
}

Map<String, dynamic> _map(Object? value) {
  return value is Map ? Map<String, dynamic>.from(value) : const {};
}
