import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/data/repo/student_certificates_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('uses protected endpoint and sorts newest first', () async {
    final api = _FakeApi({
      'data': [
        {'_id': 'old', 'issuedAt': '2025-01-01T00:00:00Z'},
        {'_id': 'new', 'issuedAt': '2026-01-01T00:00:00Z'},
      ],
    });
    final result = await StudentCertificatesRepoImpl(
      apiConsumer: api,
    ).getMyCertificates();

    expect(result.getOrElse(() => []).map((item) => item.id), ['new', 'old']);
    expect(api.path, EndPoints.myCertificates);
    expect(api.isProtected, isTrue);
  });
}

class _FakeApi implements ApiConsumer {
  _FakeApi(this.response);
  final Object? response;
  String? path;
  bool? isProtected;

  @override
  Future<Object?> get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isProtected = false,
  }) async {
    this.path = path;
    this.isProtected = isProtected;
    return response;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
