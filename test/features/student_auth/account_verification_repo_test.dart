import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/features/student_auth/data/repo/auth_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('verify account sends email and code', () async {
    final api = _Api();
    await AuthRepoImpl(
      apiConsumer: api,
    ).verifyAccount(email: ' student@bnan.edu ', code: ' 123456 ');
    expect(api.path, EndPoints.verifyAccount);
    expect(api.data, {'email': 'student@bnan.edu', 'code': '123456'});
  });

  test('resend verification sends email only', () async {
    final api = _Api();
    await AuthRepoImpl(
      apiConsumer: api,
    ).resendVerificationCode(email: ' student@bnan.edu ');
    expect(api.path, EndPoints.resendVerificationCode);
    expect(api.data, {'email': 'student@bnan.edu'});
  });
}

class _Api implements ApiConsumer {
  String? path;
  Object? data;

  @override
  Future<dynamic> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isFormData = false,
    bool isProtected = false,
  }) async {
    this.path = path;
    this.data = data;
    return {'success': true, 'message': 'ok'};
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
