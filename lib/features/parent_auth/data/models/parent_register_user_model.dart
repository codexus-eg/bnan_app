class ParentRegisterUserModel {
  const ParentRegisterUserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.phone,
  });

  final String id;
  final String fullName;
  final String email;
  final String role;
  final String status;
  final String createdAt;
  final String updatedAt;
  final String? phone;

  factory ParentRegisterUserModel.fromJson(Map<String, dynamic> json) {
    return ParentRegisterUserModel(
      id: (json['id'] ?? '').toString(),
      fullName: (json['fullName'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      role: (json['role'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      createdAt: (json['createdAt'] ?? '').toString(),
      updatedAt: (json['updatedAt'] ?? '').toString(),
      phone: json['phone']?.toString(),
    );
  }
}
