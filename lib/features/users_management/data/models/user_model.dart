class UserItem {
  const UserItem({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.registrationDate,
    required this.parentName,
    required this.classes,
    required this.roles,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.curriculum,
    required this.grade,
  });

  final String id;
  final String name;
  final String phone;
  final String email;
  final String registrationDate;
  final String parentName;
  final String classes;
  final String roles;
  final String status;
  final String createdAt;
  final String updatedAt;
  final List<String> curriculum;
  final List<String> grade;

  factory UserItem.fromJson(Map<String, dynamic> json) {
    final grade = _asList(json['grade']);
    final createdAt = _asString(json['createdAt']);

    return UserItem(
      id: _asString(json['_id'] ?? json['id']),
      name: _asString(json['fullName'] ?? json['name']),
      phone: _asString(json['phone'] ?? json['phoneNumber'] ?? json['mobile']),
      email: _asString(json['email']),
      registrationDate: _asString(json['registrationDate'] ?? createdAt),
      parentName: _asString(json['parentName'] ?? json['parent']),
      classes: _asString(json['classes'] ?? grade.join(', ')),
      roles: _asString(json['role'] ?? json['roles']),
      status: _asString(json['status']),
      createdAt: createdAt,
      updatedAt: _asString(json['updatedAt']),
      curriculum: _asList(json['curriculum']),
      grade: grade,
    );
  }

  Map<String, dynamic> toUpdateJson() {
    return {'fullName': name, 'email': email, 'phone': phone};
  }
}

String _asString(Object? value) => value?.toString().trim() ?? '';

List<String> _asList(Object? value) {
  final values = value is List ? value : [if (value != null) value];
  return values.map(_asString).where((value) => value.isNotEmpty).toList();
}
