class AddUserRequestModel {
  const AddUserRequestModel({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    required this.password,
    required this.curriculumId,
  });

  final String fullName;
  final String email;
  final String phone;
  final String role;
  final String password;
  final String curriculumId;

  Map<String, dynamic> toJson() {
    final id = curriculumId.trim();
    return {
      'fullName': fullName.trim(),
      'email': email.trim(),
      'phone': phone.trim(),
      'role': role.trim(),
      'password': password,
      'curriculum': id,
    };
  }
}
