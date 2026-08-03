import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/features/parent_auth/data/models/parent_register_request_model.dart';
import 'package:bnan_app/features/parent_auth/data/models/parent_register_response_model.dart';
import 'package:bnan_app/features/parent_auth/data/repo/parent_auth_repo_impl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const request = ParentRegisterRequestModel(
    fullName: ' Parent Name ',
    email: ' parent@bnan.edu ',
    password: ' 12345678 ',
    phone: ' 206566456 ',
    whatsappNumber: ' +201000000000 ',
  );

  test('request sends the exact trimmed API contract', () {
    expect(request.toJson(), {
      'fullName': 'Parent Name',
      'email': 'parent@bnan.edu',
      'password': '12345678',
      'phone': '206566456',
      'whatsappNumber': '+201000000000',
    });
  });

  test('response safely parses parent data and id', () {
    final response = ParentRegisterResponseModel.fromJson(_successResponse);
    expect(response.success, isTrue);
    expect(response.token, 'parent-token');
    expect(response.data.id, 'parent-1');
    expect(response.data.role, 'parent');
    expect(response.data.createdAt, '2026-08-03T03:19:01.197Z');
  });

  test('repo posts once to register-parent with the exact body', () async {
    FlutterSecureStorage.setMockInitialValues({});
    final api = _FakeApi();
    final result = await ParentAuthRepoImpl(
      apiConsumer: api,
    ).registerParent(request);

    expect(result.isRight(), isTrue);
    expect(api.calls, 1);
    expect(api.path, EndPoints.registerParent);
    expect(api.data, request.toJson());
  });
}

const _successResponse = <String, dynamic>{
  'success': true,
  'token': 'parent-token',
  'data': {
    'id': 'parent-1',
    'fullName': 'Parent Name',
    'email': 'parent@bnan.edu',
    'role': 'parent',
    'status': 'active',
    'createdAt': '2026-08-03T03:19:01.197Z',
    'updatedAt': '2026-08-03T03:19:01.197Z',
  },
};

class _FakeApi implements ApiConsumer {
  int calls = 0;
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
    calls++;
    this.path = path;
    this.data = data;
    return _successResponse;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
