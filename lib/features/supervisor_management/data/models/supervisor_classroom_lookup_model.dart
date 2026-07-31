class SupervisorClassroomLookupModel {
  const SupervisorClassroomLookupModel({this.id = '', this.name = ''});

  final String id;
  final String name;

  factory SupervisorClassroomLookupModel.fromJson(Map<String, dynamic> json) {
    return SupervisorClassroomLookupModel(
      id: (json['id'] ?? json['_id'])?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }
}
