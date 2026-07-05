import 'user_model.dart';

class UserResponseModel {
  const UserResponseModel({
    required this.success,
    required this.user,
  });

  final bool success;
  final UserItem? user;

  factory UserResponseModel.fromJson(Map<String, dynamic> json) {
    return UserResponseModel(
      success: json['success'] == true,
      user: _readUser(json['data']),
    );
  }
}

UserItem? _readUser(Object? data) {
  if (data is Map) {
    return UserItem.fromJson(Map<String, dynamic>.from(data));
  }

  if (data is List) {
    final users = data.whereType<Map>();
    return users.isEmpty
        ? null
        : UserItem.fromJson(Map<String, dynamic>.from(users.first));
  }

  return null;
}
