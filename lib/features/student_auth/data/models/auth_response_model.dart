import 'package:bnan_app/features/student_auth/data/models/auth_user_model.dart';

class AuthResponseModel {
  const AuthResponseModel({
    required this.success,
    required this.token,
    required this.user,
  });

  final bool success;
  final String token;
  final AuthUserModel user;

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    final dataJson = data is Map<String, dynamic> ? data : <String, dynamic>{};
    final nestedUser = dataJson['user'];
    final userJson = nestedUser is Map<String, dynamic>
        ? {...dataJson, ...nestedUser}
        : dataJson;

    return AuthResponseModel(
      success: json['success'] == true,
      token: (json['token'] ?? '').toString(),
      user: AuthUserModel.fromJson(userJson),
    );
  }

  bool get hasToken => token.isNotEmpty;
}
