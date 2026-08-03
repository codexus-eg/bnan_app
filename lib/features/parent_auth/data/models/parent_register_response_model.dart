import 'package:bnan_app/features/parent_auth/data/models/parent_register_user_model.dart';

class ParentRegisterResponseModel {
  const ParentRegisterResponseModel({
    required this.success,
    required this.token,
    required this.data,
  });

  final bool success;
  final String token;
  final ParentRegisterUserModel data;

  factory ParentRegisterResponseModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    return ParentRegisterResponseModel(
      success: json['success'] == true,
      token: (json['token'] ?? '').toString(),
      data: ParentRegisterUserModel.fromJson(
        rawData is Map<String, dynamic> ? rawData : <String, dynamic>{},
      ),
    );
  }

  bool get hasToken => token.isNotEmpty;
}
