import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/ideal_teacher/data/repos/supervisor_ideal_teacher_repo_impl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
  });

  tearDown(() async {
    await SessionManager.instance.clearSession();
  });

  test('uses protected supervisor teachers endpoint', () async {
    final api = _Api();
    final result = await SupervisorIdealTeacherRepoImpl(api).getTeachers();
    expect(result.isRight(), isTrue);
    expect(api.path, EndPoints.supervisorTeachers);
    expect(api.protected, isTrue);
  });

  test('posts exact ids and omits empty optional signer', () async {
    final api = _Api();
    final repo = SupervisorIdealTeacherRepoImpl(api);
    await repo.issueIdealTeachers(teacherIds: ['t1', 't2'], signerName: '  ');
    expect(api.path, EndPoints.supervisorIdealTeachers);
    expect(api.body, {
      'teacherIds': ['t1', 't2'],
    });
    await repo.issueIdealTeachers(
      teacherIds: ['t1'],
      signerName: ' Principal ',
    );
    expect(api.body, {
      'teacherId': 't1',
      'signerName': 'Principal',
    });
  });

  test('admin issuance is now authorized and sends request to supervisorIdealTeachers', () async {
    FlutterSecureStorage.setMockInitialValues({});
    await SessionManager.instance.saveSession(
      accessToken: 'token',
      refreshToken: '',
      userRole: 'admin',
    );
    final api = _Api();
    final repo = SupervisorIdealTeacherRepoImpl(api);
    final result = await repo.issueIdealTeachers(
      teacherIds: ['t1'],
      signerName: 'Admin Signer',
    );
    expect(result.isRight(), isTrue);
    expect(api.path, EndPoints.supervisorIdealTeachers);
    expect(api.body, {
      'teacherId': 't1',
      'signerName': 'Admin Signer',
    });
  });
}

class _Api implements ApiConsumer {
  String? path;
  Object? body;
  bool protected = false;
  @override
  Future<dynamic> get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isProtected = false,
  }) async {
    this.path = path;
    protected = isProtected;
    return {
      'data': [
        {'id': 't1', 'name': 'Teacher'},
      ],
    };
  }

  @override
  Future<dynamic> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isFormData = false,
    bool isProtected = false,
  }) async {
    this.path = path;
    body = data;
    protected = isProtected;
    return {'success': true};
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
