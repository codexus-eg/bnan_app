import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/features/users_management/data/repo/users_management_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('get users sends the existing search and role contract', () async {
    final api = _Api();
    await UsersManagementRepoImpl(
      api,
    ).getUsers(page: 2, search: 'Ahmed', role: 'teacher');

    expect(api.path, EndPoints.users);
    expect(api.query, {'page': 2, 'search': 'Ahmed', 'role': 'teacher'});
  });

  test('get users omits empty search and role values', () async {
    final api = _Api();
    await UsersManagementRepoImpl(api).getUsers(page: 1, search: '', role: '');

    expect(api.query, {'page': 1});
  });
}

class _Api implements ApiConsumer {
  String? path;
  Map<String, dynamic>? query;

  @override
  Future<dynamic> get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isProtected = false,
  }) async {
    this.path = path;
    query = queryParameter;
    return {
      'success': true,
      'results': 0,
      'pagination': <String, dynamic>{},
      'data': <Object>[],
    };
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
