import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/features/packages_management/data/models/package_model.dart';
import 'package:bnan_app/features/payments/data/models/gulf_payment_provider.dart';
import 'package:bnan_app/features/payments/data/models/payment_draft.dart';
import 'package:bnan_app/features/payments/data/models/payment_status.dart';
import 'package:bnan_app/features/payments/data/models/tamara_checkout_request.dart';
import 'package:bnan_app/features/payments/data/models/tamara_checkout_response.dart';
import 'package:bnan_app/features/payments/data/models/tamara_status_response.dart';
import 'package:bnan_app/features/payments/data/models/tamara_return.dart';
import 'package:bnan_app/features/student_auth/data/models/auth_response_model.dart';
import 'package:bnan_app/features/student_auth/data/models/register_student_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('only Tamara provider can launch Tamara checkout', () {
    expect(GulfPaymentProvider.tamara.usesTamaraCheckout, isTrue);
    expect(GulfPaymentProvider.paymob.usesTamaraCheckout, isFalse);
  });

  test('parses only registered Tamara return URLs', () {
    for (final outcome in TamaraReturnOutcome.values) {
      final result = TamaraReturn.tryParse(
        Uri.parse('bnanacademy://payment/tamara/${outcome.name}'),
      );
      expect(result?.outcome, outcome);
    }
    expect(
      TamaraReturn.tryParse(Uri.parse('https://payment/tamara/success')),
      isNull,
    );
    expect(
      TamaraReturn.tryParse(Uri.parse('bnanacademy://other/tamara/success')),
      isNull,
    );
  });

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
    expect(json['provider'], 'tamara');
    expect(json['paymentAddress'], _request.address.toJson());
    expect((json['student'] as Map)['email'], 'student@example.com');
    expect((json['student'] as Map).containsKey('username'), isFalse);
    expect(json.containsKey('price'), isFalse);
    expect(json.containsKey('currency'), isFalse);
  });

  test('Paymob registration payload omits paymentAddress', () {
    final json = TamaraCheckoutRequest(
      parentEmail: _request.parentEmail,
      parentPassword: _request.parentPassword,
      student: _request.student,
      curriculumId: _request.curriculumId,
      packageId: _request.packageId,
      address: _request.address,
      provider: GulfPaymentProvider.paymob,
    ).toJson();
    expect(json['provider'], 'paymob');
    expect(json, isNot(contains('paymentAddress')));
  });

  test('payment status endpoint includes provider', () {
    expect(EndPoints.paymentCheckout, '/payment/checkout');
    expect(
      EndPoints.paymentStatus(GulfPaymentProvider.tamara, 'payment-1'),
      '/payment/tamara/payment-1/status',
    );
    expect(
      EndPoints.paymentStatus(GulfPaymentProvider.paymob, 'payment-1'),
      '/payment/paymob/payment-1/status',
    );
  });

  test('sends only a non-empty discount code and no calculated amounts', () {
    final json = TamaraCheckoutRequest(
      parentEmail: _request.parentEmail,
      parentPassword: _request.parentPassword,
      student: _request.student,
      curriculumId: _request.curriculumId,
      packageId: _request.packageId,
      address: _request.address,
      discountCode: ' FAMILY25 ',
    ).toJson();
    expect(json['discountCode'], 'FAMILY25');
    expect(json, isNot(contains('discountAmount')));
    expect(json, isNot(contains('finalAmount')));
    expect(json, isNot(contains('percentage')));
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

  test('parses flexible server discount amounts on checkout and status', () {
    final json = {
      'data': {
        'originalAmount': '500',
        'discountAmount': 125,
        'finalAmount': 375.0,
        'currency': 'SAR',
        'discount': {
          'code': 'FAMILY25',
          'type': 'children',
          'percentage': '25',
          'childrenCount': 3.0,
        },
      },
    };
    final checkout = TamaraCheckoutResponse.fromJson(json);
    final status = TamaraStatusResponse.fromJson(json);
    expect(checkout.paymentSummary?.finalAmount, 375);
    expect(status.paymentSummary?.discount?.childrenCount, 3);
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

  test('legacy drafts default to Tamara and infer their purpose', () {
    final registration = PaymentDraft.fromJson({
      'lastKnownStatus': 'pending',
      'paymentStartedAt': DateTime(2026).toIso8601String(),
      'payloadFingerprint': 'registration-fingerprint',
    });
    final addChild = PaymentDraft.fromJson({
      'lastKnownStatus': 'pending',
      'paymentStartedAt': DateTime(2026).toIso8601String(),
      'payloadFingerprint': 'parent_add_child:fingerprint',
    });
    expect(registration.provider, GulfPaymentProvider.tamara);
    expect(registration.purpose, PaymentDraftPurpose.registration);
    expect(addChild.provider, GulfPaymentProvider.tamara);
    expect(addChild.purpose, PaymentDraftPurpose.addChild);
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
