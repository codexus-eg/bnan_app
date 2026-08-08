import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/payout_profile_request.dart';
import 'package:bnan_app/features/teacher_payrolls/data/repo/teacher_payroll_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('uses confirmed payout profile endpoint and exact fields', () async {
    final api = _Api();
    final repo = TeacherPayrollRepoImpl(api);
    await repo.updatePayoutProfile(
      't1',
      const PayoutProfileRequest(
        method: 'instapay',
        accountHolderName: 'Ahmed',
        instapayAddress: 'a@instapay',
      ),
    );
    expect(api.path, '/admin/payrolls/teachers/t1/payout-profile');
    expect(api.data, {
      'method': 'instapay',
      'accountHolderName': 'Ahmed',
      'instapayAddress': 'a@instapay',
    });
  });
  test('preview list sends filters only on explicit repository call', () async {
    final api = _Api();
    final repo = TeacherPayrollRepoImpl(api);
    await repo.getPreviewList(
      from: '2026-08-01',
      to: '2026-08-31',
      teacherId: 't1',
    );
    expect(api.path, '/admin/payrolls/preview');
    expect(api.query, {
      'from': '2026-08-01',
      'to': '2026-08-31',
      'teacherId': 't1',
    });
  });
}

class _Api implements ApiConsumer {
  String path = '';
  Object? data;
  Map<String, dynamic>? query;
  dynamic _record(String value, Object? body, Map<String, dynamic>? params) {
    path = value;
    data = body;
    query = params;
    return {'success': true, 'data': {}};
  }

  @override
  Future get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isProtected = false,
  }) async => _record(path, data, queryParameter);
  @override
  Future post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isFormData = false,
    bool isProtected = false,
  }) async => _record(path, data, queryParameter);
  @override
  Future put(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isFormData = false,
    bool isProtected = false,
  }) async => _record(path, data, queryParameter);
  @override
  Future patch(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isFormData = false,
    bool isProtected = false,
  }) async => _record(path, data, queryParameter);
  @override
  Future delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isFormData = false,
    bool isProtected = false,
  }) async => _record(path, data, queryParameter);
}
