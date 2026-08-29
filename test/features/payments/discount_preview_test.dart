import 'dart:async';

import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/parent_children/data/models/parent_payment_address.dart';
import 'package:bnan_app/features/parent_subscriptions/data/models/gulf_renewal_request.dart';
import 'package:bnan_app/features/payments/data/models/discount_preview_request.dart';
import 'package:bnan_app/features/payments/data/models/discount_preview_requests.dart';
import 'package:bnan_app/features/payments/data/models/gulf_payment_provider.dart';
import 'package:bnan_app/features/payments/data/models/payment_amount_summary.dart';
import 'package:bnan_app/features/payments/data/models/payment_discount_model.dart';
import 'package:bnan_app/features/payments/data/repo/discount_preview_repo.dart';
import 'package:bnan_app/features/payments/data/repo/discount_preview_repo_impl.dart';
import 'package:bnan_app/features/payments/presentation/manager/discount_preview_cubit.dart';
import 'package:bnan_app/features/payments/presentation/policies/discount_preview_error_mapper.dart';
import 'package:bnan_app/features/payments/presentation/widgets/discount_preview_field.dart';
import 'package:bnan_app/features/payments/presentation/widgets/discount_preview_summary.dart';
import 'package:bnan_app/features/student_auth/data/models/register_flow_args_model.dart';
import 'package:bnan_app/features/student_auth/data/repo/auth_repo.dart';
import 'package:bnan_app/features/student_auth/data/repo/gulf_parent_auth_repo.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/register_cubit/register_cubit.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() => S.load(const Locale('en')));

  test('valid coupon uses official endpoint and expected auth', () async {
    final api = _FakeApi();
    final request = DiscountPreviewRequests.subject(_subject('SAVE'));
    final result = await DiscountPreviewRepoImpl(api).preview(request);
    expect(result.isRight(), isTrue);
    expect(api.path, EndPoints.discountPreview);
    expect(api.protected, isTrue);
    expect(api.data, request.toJson());
  });

  test('registration payload uses items and excludes checkout fields', () {
    final request = DiscountPreviewRequests.registration({
      'provider': 'tamara',
      'parent': {'email': 'p@test.com', 'password': 'secret'},
      'student': {..._student(), 'password': 'student-secret'},
      'curriculum': 'curriculum-1',
      'items': [
        {'subjectId': 'subject-1', 'packageId': 'package-1'},
      ],
      'discountCode': 'SAVE',
      'paymentAddress': {'city': 'Riyadh'},
      'locale': 'ar_SA',
    });
    expect(request.isProtected, isFalse);
    expect(request.toJson()['purchaseType'], 'student_registration');
    expect(request.toJson()['items'], isNotEmpty);
    expect((request.toJson()['student'] as Map).containsKey('password'), false);
    expect(request.toJson().containsKey('provider'), false);
  });

  test(
    'registration preview and checkout share items and discount code',
    () async {
      final register = RegisterCubit(_UnusedAuthRepo(), _UnusedParentRepo())
        ..setRegisterFlowArgs(
          const RegisterFlowArgsModel(
            curriculumId: 'curriculum-1',
            curriculumName: 'Gulf',
            packageId: 'package-1',
            packageName: 'Package',
            packagePrice: '100',
            packageCurrency: 'SAR',
            registrationMode: 'gulf',
            accessScope: 'single_subject',
          ),
        )
        ..selectedGradeId = 'grade-1'
        ..selectedSubjectIds = ['subject-1', 'subject-2', 'subject-3']
        ..discountCodeController.text = ' SAVE ';

      final checkout = register.buildTamaraRequest(validateForm: false)!;
      final preview = register.buildDiscountPreviewRequest()!;

      expect(checkout.items, hasLength(3));
      expect(checkout.discountCode, 'SAVE');
      expect(preview.purchaseType, 'student_registration');
      expect(preview.payload['items'], hasLength(3));
      expect(preview.discountCode, checkout.discountCode);
      expect(register.checkoutOriginalAmount, 300);
      await register.close();
    },
  );

  test('add-child payload is protected and matches contract', () {
    final request = DiscountPreviewRequests.addChild({
      'provider': 'paymob',
      'student': {..._student(), 'password': 'secret'},
      'curriculum': 'curriculum-1',
      'packageId': 'package-1',
      'discountCode': 'SAVE',
    });
    expect(request.isProtected, isTrue);
    expect(request.toJson()['purchaseType'], 'parent_add_child');
    expect(request.toJson()['packageId'], 'package-1');
    expect((request.toJson()['student'] as Map).containsKey('password'), false);
  });

  test('renewal and subject-request payloads preserve required ids', () {
    final renewal = DiscountPreviewRequests.renewal({
      'studentId': 'student-1',
      'subscriptionId': 'subscription-1',
      'packageId': 'package-1',
      'subjectId': 'subject-1',
      'discountCode': 'SAVE',
    });
    expect(renewal.toJson()['purchaseType'], 'subscription_renewal');
    expect(renewal.toJson()['subscriptionId'], 'subscription-1');
    final subject = DiscountPreviewRequests.subject(_subject('SAVE'));
    expect(subject.toJson(), {
      'purchaseType': 'subject_request',
      ..._subject('SAVE'),
    });
  });

  test(
    'provider changes keep preview, package changes make it stale',
    () async {
      final repo = _FakeRepo();
      final cubit = DiscountPreviewCubit(repo);
      final first = DiscountPreviewRequests.registration(
        _checkout(provider: 'tamara', packageId: 'package-1'),
      );
      await cubit.apply(first);
      final paymob = DiscountPreviewRequests.registration(
        _checkout(provider: 'paymob', packageId: 'package-1'),
      );
      expect(cubit.state.matches(paymob.fingerprint), isTrue);
      final changed = DiscountPreviewRequests.registration(
        _checkout(provider: 'paymob', packageId: 'package-2'),
      );
      expect(cubit.state.matches(changed.fingerprint), isFalse);
      await cubit.close();
    },
  );

  test('coupon edit clears preview and discards late responses', () async {
    final pending = Completer<Either<Failure, PaymentAmountSummary>>();
    final cubit = DiscountPreviewCubit(_PendingRepo(pending.future));
    final request = DiscountPreviewRequests.subject(_subject('OLD'));
    final apply = cubit.apply(request);
    cubit.invalidate();
    pending.complete(const Right(_summary));
    await apply;
    expect(cubit.state.summary, isNull);
    await cubit.close();
  });

  test('invalid coupon uses localized friendly error', () {
    expect(
      mapDiscountPreviewFailure(
        Failure(message: 'raw backend', code: 'INVALID_DISCOUNT_CODE'),
      ),
      S.current.discountPreviewInvalidCode,
    );
  });

  testWidgets('Apply only calls preview and renders backend amounts', (
    tester,
  ) async {
    final repo = _FakeRepo();
    final cubit = DiscountPreviewCubit(repo);
    final controller = TextEditingController(text: 'SAVE');
    DiscountPreviewRequest request() =>
        DiscountPreviewRequests.subject(_subject(controller.text));
    await tester.pumpWidget(
      _app(
        cubit,
        Column(
          children: [
            DiscountPreviewField(
              controller: controller,
              request: request,
              onChanged: (_) {},
            ),
            DiscountPreviewSummary(request: request),
          ],
        ),
      ),
    );
    await tester.tap(find.text(S.current.applyDiscountCode));
    await tester.pump();
    expect(repo.calls, 1);
    expect(find.text('200 SAR'), findsOneWidget);
    expect(find.text('40 SAR (20%)'), findsOneWidget);
    expect(find.text('160 SAR'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField), 'NEW');
    await tester.pump();
    expect(find.text('160 SAR'), findsNothing);
    expect(repo.calls, 1);
    controller.dispose();
    await cubit.close();
  });

  testWidgets('shared discount UI stays single-line in RTL', (tester) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final cubit = DiscountPreviewCubit(_FakeRepo());
    final controller = TextEditingController(text: 'SAVE');
    DiscountPreviewRequest request() =>
        DiscountPreviewRequests.subject(_subject(controller.text));
    await tester.pumpWidget(
      _app(
        cubit,
        Column(
          children: [
            DiscountPreviewField(
              controller: controller,
              request: request,
              onChanged: (_) {},
            ),
            DiscountPreviewSummary(request: request),
          ],
        ),
        locale: const Locale('ar'),
      ),
    );
    final button = tester.widget<CustomAppButton>(find.byType(CustomAppButton));
    final buttonBox = tester.widget<SizedBox>(
      find.ancestor(
        of: find.byType(CustomAppButton),
        matching: find.byType(SizedBox),
      ),
    );
    expect(button.singleLine, isTrue);
    expect(buttonBox.width, 104);
    await tester.tap(find.byType(CustomAppButton));
    await tester.pump();
    expect(find.text('200 SAR'), findsOneWidget);
    expect(find.text('40 SAR (20%)'), findsOneWidget);
    final finalAmount = tester.widget<Text>(find.text('160 SAR'));
    expect(finalAmount.style?.fontSize, 18);
    expect(finalAmount.style?.color, ColorManager.mainColor15);
    expect(tester.takeException(), isNull);
    controller.dispose();
    await cubit.close();
  });

  test('Confirm renewal request still sends the current discount code', () {
    const request = GulfRenewalRequest(
      subscriptionId: 'subscription-1',
      packageId: 'package-1',
      discountCode: ' SAVE ',
      paymentAddress: ParentPaymentAddress(
        city: 'Riyadh',
        region: 'Riyadh',
        line1: 'Line 1',
      ),
      provider: GulfPaymentProvider.paymob,
    );
    expect(request.toJson()['discountCode'], 'SAVE');
  });
}

const _summary = PaymentAmountSummary(
  originalAmount: 200,
  discountAmount: 40,
  finalAmount: 160,
  currency: 'SAR',
  discount: PaymentDiscountModel(
    code: 'SAVE',
    type: 'date_range',
    percentage: 20,
  ),
);

Map<String, dynamic> _student() => {
  'fullName': 'Student',
  'email': 'student@test.com',
  'grade': 'grade-1',
  'subjects': ['subject-1'],
};

Map<String, dynamic> _subject(String code) => {
  'subjectId': 'subject-1',
  'packageId': 'package-1',
  'discountCode': code,
};

Map<String, dynamic> _checkout({
  required String provider,
  required String packageId,
}) => {
  'provider': provider,
  'parent': {'email': 'p@test.com', 'password': 'secret'},
  'student': {..._student(), 'password': 'secret'},
  'curriculum': 'curriculum-1',
  'packageId': packageId,
  'discountCode': 'SAVE',
};

Widget _app(
  DiscountPreviewCubit cubit,
  Widget child, {
  Locale locale = const Locale('en'),
}) => MaterialApp(
  locale: locale,
  localizationsDelegates: const [
    S.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: S.delegate.supportedLocales,
  home: Scaffold(
    body: BlocProvider.value(value: cubit, child: child),
  ),
);

class _FakeRepo implements DiscountPreviewRepo {
  int calls = 0;
  @override
  Future<Either<Failure, PaymentAmountSummary>> preview(
    DiscountPreviewRequest request,
  ) async {
    calls++;
    return const Right(_summary);
  }
}

class _PendingRepo implements DiscountPreviewRepo {
  const _PendingRepo(this.result);
  final Future<Either<Failure, PaymentAmountSummary>> result;
  @override
  Future<Either<Failure, PaymentAmountSummary>> preview(
    DiscountPreviewRequest request,
  ) => result;
}

class _FakeApi implements ApiConsumer {
  String? path;
  Object? data;
  bool? protected;

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
    protected = isProtected;
    return {'data': _summaryJson};
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _UnusedAuthRepo implements AuthRepo {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _UnusedParentRepo implements GulfParentAuthRepo {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

const _summaryJson = {
  'originalAmount': 200,
  'discountAmount': 40,
  'finalAmount': 160,
  'currency': 'SAR',
  'discount': {'code': 'SAVE', 'type': 'date_range', 'percentage': 20},
};
