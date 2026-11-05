class ClassroomEligibleSubject {
  const ClassroomEligibleSubject({
    required this.id,
    required this.name,
    required this.isAssigned,
  });

  final String id;
  final String name;
  final bool isAssigned;

  factory ClassroomEligibleSubject.fromJson(Map<String, dynamic> json) {
    return ClassroomEligibleSubject(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      isAssigned: json['isAssigned'] == true,
    );
  }
}
