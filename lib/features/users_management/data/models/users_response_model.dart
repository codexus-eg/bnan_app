import 'user_model.dart';
import 'users_pagination_model.dart';

class UsersResponseModel {
  const UsersResponseModel({
    required this.success,
    required this.results,
    required this.pagination,
    required this.data,
  });

  final bool success;
  final int results;
  final UsersPaginationModel pagination;
  final List<UserItem> data;

  factory UsersResponseModel.fromJson(Map<String, dynamic> json) {
    final users = json['data'];

    return UsersResponseModel(
      success: json['success'] == true,
      results: int.tryParse(json['results']?.toString() ?? '') ?? 0,
      pagination: UsersPaginationModel.fromJson(
        json['pagination'] is Map
            ? Map<String, dynamic>.from(json['pagination'])
            : <String, dynamic>{},
      ),
      data: users is List
          ? users
              .whereType<Map>()
              .map((user) => UserItem.fromJson(Map<String, dynamic>.from(user)))
              .toList()
          : const [],
    );
  }
}
