import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/student_auth/data/repo/auth_repo_impl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    FlutterSecureStorage.setMockInitialValues({});
    await SessionManager.instance.clearSession();
    await SessionManager.instance.saveSession(
      accessToken: 'parent-token',
      refreshToken: '',
      userId: 'parent-1',
      userRole: 'parent',
    );
  });

  test('failed student validation keeps parent session untouched', () async {
    final repo = AuthRepoImpl(
      apiConsumer: _LoginApi(role: 'teacher', status: 'active'),
    );
    final result = await repo.loginStudentAfterPayment(
      email: ' student@example.com ',
      password: 'Password123',
    );
    expect(result.isLeft(), isTrue);
    expect(SessionManager.instance.accessToken, 'parent-token');
    expect(SessionManager.instance.userRole, 'parent');
  });

  test('active student replaces parent session after validation', () async {
    final api = _LoginApi(role: 'student', status: 'active');
    final repo = AuthRepoImpl(apiConsumer: api);
    final result = await repo.loginStudentAfterPayment(
      email: ' student@example.com ',
      password: 'Password123',
    );
    expect(result.isRight(), isTrue);
    expect(api.email, 'student@example.com');
    expect(SessionManager.instance.accessToken, 'student-token');
    expect(SessionManager.instance.userRole, 'student');
  });
}

class _LoginApi implements ApiConsumer {
  _LoginApi({required this.role, required this.status});

  final String role;
  final String status;
  String? email;

  @override
  Future<dynamic> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isFormData = false,
    bool isProtected = false,
  }) async {
    email = (data as Map<String, dynamic>)['email'] as String?;
    return {
      'success': true,
      'token': 'student-token',
      'data': {
        'id': 'student-1',
        'fullName': 'Student',
        'email': email,
        'role': role,
        'status': status,
      },
    };
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
