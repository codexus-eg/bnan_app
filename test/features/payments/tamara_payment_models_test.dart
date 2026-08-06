import 'package:bnan_app/features/packages_management/data/models/package_model.dart';
import 'package:bnan_app/features/payments/data/models/payment_draft.dart';
import 'package:bnan_app/features/payments/data/models/payment_status.dart';
import 'package:bnan_app/features/payments/data/models/tamara_checkout_request.dart';
import 'package:bnan_app/features/payments/data/models/tamara_checkout_response.dart';
import 'package:bnan_app/features/payments/data/models/tamara_status_response.dart';
import 'package:bnan_app/features/student_auth/data/models/auth_response_model.dart';
import 'package:bnan_app/features/student_auth/data/models/register_student_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parent auth token is parsed from response root', () {
    final response = AuthResponseModel.fromJson({
      'success': true,
      'token': 'root-token',
      'data': {'id': 'p1', 'role': 'parent', 'status': 'active'},
    });
    expect(response.token, 'root-token');
  });

  test('username value becomes student email without username or price', () {
    final json = _request.toJson();
    expect((json['student'] as Map)['email'], 'student@example.com');
    expect((json['student'] as Map).containsKey('username'), isFalse);
    expect(json.containsKey('price'), isFalse);
    expect(json.containsKey('currency'), isFalse);
  });

  test('parses hours and monthly packages safely', () {
    final hours = PackageModel.fromJson({
      'type': 'hours',
      'hours': '20',
      'price': '1000',
      'isActive': true,
    });
    final monthly = PackageModel.fromJson({
      'type': 'monthly',
      'months': 1.0,
      'price': 1000,
      'isActive': false,
    });
    expect(hours.hours, 20);
    expect(hours.price, 1000);
    expect(hours.isActive, isTrue);
    expect(monthly.months, 1);
    expect(monthly.isActive, isFalse);
  });

  test('handles missing checkout URL and unknown status', () {
    final checkout = TamaraCheckoutResponse.fromJson({
      'data': {'paymentId': 'payment-1', 'checkoutUrl': 12},
    });
    final status = TamaraStatusResponse.fromJson({
      'data': {'paymentId': 'payment-1', 'status': 'future_status'},
    });
    expect(checkout.checkoutUrl, isNull);
    expect(status.status, PaymentStatus.unknown);
  });

  test('persisted draft contains no parent or student password', () {
    final json = PaymentDraft(
      paymentId: 'payment-1',
      idempotencyKey: 'key',
      packageId: 'package-1',
      curriculumId: 'curriculum-1',
      gradeId: 'grade-1',
      subjectIds: const ['subject-1'],
      studentEmail: 'student@example.com',
      paymentStartedAt: DateTime(2026),
      lastKnownStatus: PaymentStatus.pending,
    ).toJson();
    expect(json.keys, isNot(contains('parentPassword')));
    expect(json.keys, isNot(contains('studentPassword')));
  });
}

const _request = TamaraCheckoutRequest(
  parentEmail: 'parent@example.com',
  parentPassword: 'ParentPass123',
  student: RegisterStudentModel(
    fullName: 'Student',
    email: 'student@example.com',
    password: 'StudentPass123',
    grade: 'grade-1',
    subjects: ['subject-1'],
  ),
  curriculumId: 'curriculum-1',
  packageId: 'package-1',
  address: PaymentAddress(city: 'Riyadh', region: 'Riyadh', line1: 'Address'),
);
