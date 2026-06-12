class RegisterParentModel {
  const RegisterParentModel({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.password,
    required this.whatsappNumber,
  });

  final String fullName;
  final String email;
  final String phone;
  final String password;
  final String whatsappNumber;

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'password': password,
      'whatsappNumber': whatsappNumber,
    };
  }
}