import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/payout_method.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/payout_profile_request.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/save_payroll_request.dart';
import 'package:bnan_app/features/teacher_payrolls/data/repo/teacher_payroll_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('my payrolls sends no teacher id and supports draft filter', () async {
    final api = _Api();
    await TeacherPayrollRepoImpl(api).getMyPayrolls(status: 'draft');
    expect(api.path, '/teachers/me/payroll-statements');
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
    expect(api.path, '/teachers/me/payroll-statements/p1');
    expect(api.protected, isTrue);
  });
  test('my payrolls without filter sends no query or teacher id', () async {
    final api = _Api();
    await TeacherPayrollRepoImpl(api).getMyPayrolls();
    expect(api.path, '/teachers/me/payroll-statements');
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

  test(
      'statement preview queries /admin/payrolls/statement-preview with curriculumId, from, and to',
      () async {
    final api = _Api();
    final repo = TeacherPayrollRepoImpl(api);
    await repo.getStatementPreview(
      curriculumId: 'curr_egypt',
      from: '2026-10-01',
      to: '2026-10-31',
    );
    expect(api.path, '/admin/payrolls/statement-preview');
    expect(api.query, {
      'from': '2026-10-01',
      'to': '2026-10-31',
      'curriculumId': 'curr_egypt',
    });
  });

  test(
      'sendStatement posts to admin payroll statement send endpoint without body',
      () async {
    final api = _Api(response: {
      'data': {'id': 'stmt_123', 'status': 'sent'},
    });
    final repo = TeacherPayrollRepoImpl(api);
    final result = await repo.sendStatement('stmt_123');
    expect(api.path, '/admin/payrolls/statements/stmt_123/send');
    expect(api.data, isNull);
    result.fold(
      (f) => fail('Expected success: ${f.message}'),
      (val) => expect(val.status, 'sent'),
    );
  });

  test('SavePayrollRequest serializes gradeRates and courseRates correctly',
      () {
    const request = SavePayrollRequest(
      teacherId: 't1',
      curriculumId: 'c1',
      from: '2026-10-01',
      to: '2026-10-31',
      currency: 'EGP',
      academicCurrency: 'EGP',
      courseCurrency: 'EGP',
      generalAmount: 1500,
      bonuses: 200,
      deductions: 100,
      gradeRates: [PayrollGradeRateRequest(gradeId: 'g1', hourlyRate: 120)],
      courseRates: [PayrollCourseRateRequest(courseId: 'cr1', hourlyRate: 100)],
    );
    final json = request.toJson();
    expect(json['teacherId'], 't1');
    expect(json['curriculumId'], 'c1');
    expect(json['currency'], 'EGP');
    expect(json['academicCurrency'], 'EGP');
    expect(json['courseCurrency'], 'EGP');
    expect(json['generalAmount'], 1500);
    expect(json['bonuses'], 200);
    expect(json['deductions'], 100);
    expect(json['gradeRates'], [
      {'gradeId': 'g1', 'hourlyRate': 120},
    ]);
    expect(json['courseRates'], [
      {'courseId': 'cr1', 'hourlyRate': 100},
    ]);
  });

  test(
      'SavePayrollRequest omits courseCurrency when no courses and academicCurrency when no grades',
      () {
    const requestOnlyGrades = SavePayrollRequest(
      currency: 'EGP',
      gradeRates: [PayrollGradeRateRequest(gradeId: 'g1', hourlyRate: 100)],
    );
    expect(requestOnlyGrades.toJson()['academicCurrency'], 'EGP');
    expect(requestOnlyGrades.toJson().containsKey('courseCurrency'), isFalse);

    const requestOnlyCourses = SavePayrollRequest(
      currency: 'SAR',
      courseRates: [PayrollCourseRateRequest(courseId: 'cr1', hourlyRate: 80)],
    );
    expect(requestOnlyCourses.toJson()['courseCurrency'], 'SAR');
    expect(requestOnlyCourses.toJson().containsKey('academicCurrency'), isFalse);
  });

  test('receipt endpoints match backend contract for Admin and Teacher', () {
    expect(
      EndPoints.adminPayrollStatementReceipt('stmt_1'),
      '/admin/payrolls/statements/stmt_1/payment/receipt',
    );
    expect(
      EndPoints.teacherMyPayrollStatementReceipt('stmt_2'),
      '/teachers/me/payroll-statements/stmt_2/payment/receipt',
    );
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
