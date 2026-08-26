import 'package:bnan_app/core/error/app_exception.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/features/student_auth/data/models/register_parent_model.dart';
import 'package:bnan_app/features/student_auth/data/repo/gulf_parent_auth_repo.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('missing login does not create a partial parent account', () async {
    final api = _MissingApi();
    final result = await GulfParentAuthRepoImpl(api).authenticate(
      const RegisterParentModel(email: 'parent@bnan.edu', password: '12345678'),
    );

    expect(result.isLeft(), isTrue);
    expect(api.calls, 1);
    expect(api.paths, [EndPoints.login]);
  });
}

class _MissingApi implements ApiConsumer {
  int calls = 0;
  final paths = <String>[];

  @override
  Future<dynamic> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isFormData = false,
    bool isProtected = false,
  }) async {
    calls++;
    paths.add(path);
    throw const AppException(
      'not found',
      responseReceived: true,
      statusCode: 404,
      code: 'USER_NOT_FOUND',
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
