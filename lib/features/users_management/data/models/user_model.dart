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
    this.registrationMode = '',
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
  final String registrationMode;

  factory UserItem.fromJson(Map<String, dynamic> json) {
    final grade = _asList(json['grade']);
    final classes = _asList(json['classes']);
    final createdAt = _asString(json['createdAt']);

    return UserItem(
      id: _asString(json['_id'] ?? json['id']),
      name: _asString(json['fullName'] ?? json['name']),
      phone: _asString(json['phone'] ?? json['phoneNumber'] ?? json['mobile']),
      email: _asString(json['email']),
      registrationDate: _asString(json['registrationDate'] ?? createdAt),
      parentName: _asString(json['parentName'] ?? json['parent']),
      classes: classes.isEmpty ? grade.join(', ') : classes.join(', '),
      roles: _asList(json['roles'] ?? json['role']).join(', '),
      status: _asString(json['status']),
      createdAt: createdAt,
      updatedAt: _asString(json['updatedAt']),
      curriculum: _asList(json['curriculum']),
      grade: grade,
      registrationMode: _asList(
        json['registrationModes'] ?? json['registrationMode'],
      ).join(', '),
    );
  }

  Map<String, dynamic> toUpdateJson() {
    return {'fullName': name, 'email': email, 'phone': phone};
  }
}

String _asString(Object? value) {
  if (value is Map) {
    return _asString(
      value['fullName'] ?? value['name'] ?? value['id'] ?? value['_id'],
    );
  }
  return value?.toString().trim() ?? '';
}

List<String> _asList(Object? value) {
  final values = value is List ? value : [if (value != null) value];
  return values.map(_asString).where((value) => value.isNotEmpty).toList();
}
