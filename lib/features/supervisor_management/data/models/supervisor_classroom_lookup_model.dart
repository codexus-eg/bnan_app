class SupervisorClassroomLookupModel {
  const SupervisorClassroomLookupModel({
    this.id = '',
    this.name = '',
    this.registrationMode,
  });

  final String id;
  final String name;
  final String? registrationMode;

  factory SupervisorClassroomLookupModel.fromJson(Map<String, dynamic> json) {
    return SupervisorClassroomLookupModel(
      id: (json['id'] ?? json['_id'])?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      registrationMode: json['registrationMode']?.toString(),
    );
  }
}
