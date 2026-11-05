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
    final nestedClassroom = json['classroom'];
    final map = nestedClassroom is Map
        ? Map<String, dynamic>.from(nestedClassroom)
        : json;
    return SupervisorClassroomModel(
      id: (map['id'] ?? map['_id'])?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      grade: SupervisorClassroomLookupModel.fromJson(_map(map['grade'])),
      curriculum: SupervisorClassroomLookupModel.fromJson(
        _map(map['curriculum']),
      ),
    );
  }
}

Map<String, dynamic> _map(Object? value) {
  return value is Map ? Map<String, dynamic>.from(value) : const {};
}
