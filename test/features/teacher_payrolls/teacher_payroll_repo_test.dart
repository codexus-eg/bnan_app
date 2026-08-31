import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/payout_method.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/payout_profile_request.dart';
import 'package:bnan_app/features/teacher_payrolls/data/repo/teacher_payroll_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('my payrolls sends no teacher id and supports draft filter', () async {
    final api = _Api();
    await TeacherPayrollRepoImpl(api).getMyPayrolls(status: 'draft');
    expect(api.path, '/teachers/me/payrolls');
    expect(api.query, {'status': 'draft'});
    expect(api.protected, isTrue);
  });
  test('my payrolls supports paid filter', () async {
    final api = _Api();
    await TeacherPayrollRepoImpl(api).getMyPayrolls(status: 'paid');
    expect(api.query, {'status': 'paid'});
  });
  test('my payroll detail uses teacher endpoint', () async {
    final api = _Api();
    await TeacherPayrollRepoImpl(api).getMyPayroll('p1');
    expect(api.path, '/teachers/me/payrolls/p1');
    expect(api.protected, isTrue);
  });
  test('my payrolls without filter sends no query or teacher id', () async {
    final api = _Api();
    await TeacherPayrollRepoImpl(api).getMyPayrolls();
    expect(api.path, '/teachers/me/payrolls');
    expect(api.query, isNull);
  });
  test('my payout profile accepts null data', () async {
    final api = _Api(response: {'success': true, 'data': null});
    final result = await TeacherPayrollRepoImpl(api).getMyPayoutProfile();
    result.fold(
      (_) => fail('unexpected failure'),
      (value) => expect(value, isNull),
    );
  });
  test('my payout profile parses existing data', () async {
    final api = _Api(
      response: {
        'data': {'method': 'instapay', 'instapayAddress': 'a@instapay'},
      },
    );
    final result = await TeacherPayrollRepoImpl(api).getMyPayoutProfile();
    result.fold(
      (_) => fail('unexpected failure'),
      (value) => expect(value?.instapayAddress, 'a@instapay'),
    );
    expect(api.path, '/teachers/me/payout-profile');
    expect(api.protected, isTrue);
  });
  test('uses confirmed payout profile endpoint and exact fields', () async {
    final api = _Api();
    final repo = TeacherPayrollRepoImpl(api);
    await repo.updatePayoutProfile(
      't1',
      const PayoutProfileRequest(
        method: PayoutMethod.instapay,
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
  test('saves my payout profile without a teacher id', () async {
    final api = _Api(
      response: {
        'data': {'method': 'instapay', 'instapayAddress': 'a@instapay'},
      },
    );
    await TeacherPayrollRepoImpl(api).saveMyPayoutProfile(
      const PayoutProfileRequest(
        method: PayoutMethod.instapay,
        accountHolderName: 'Ahmed',
        instapayAddress: 'a@instapay',
      ),
    );
    expect(api.path, '/teachers/me/payout-profile');
    expect(api.protected, isTrue);
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
  _Api({this.response = const {'success': true, 'data': {}}});
  final Object response;
  String path = '';
  Object? data;
  Map<String, dynamic>? query;
  bool protected = false;
  dynamic _record(String value, Object? body, Map<String, dynamic>? params) {
    path = value;
    data = body;
    query = params;
    return response;
  }

  @override
  Future get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isProtected = false,
  }) async {
    protected = isProtected;
    return _record(path, data, queryParameter);
  }

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
  }) async {
    protected = isProtected;
    return _record(path, data, queryParameter);
  }

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
