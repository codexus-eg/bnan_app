import 'package:bnan_app/core/cache/cache_helper.dart';
import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/payments/data/models/payment_draft.dart';
import 'package:bnan_app/features/payments/data/models/payment_status.dart';
import 'package:bnan_app/features/payments/data/models/gulf_payment_provider.dart';
import 'package:bnan_app/features/payments/data/models/tamara_status_response.dart';
import 'package:bnan_app/features/payments/data/payment_draft_store.dart';
import 'package:bnan_app/features/payments/data/repo/tamara_payment_repo.dart';
import 'package:bnan_app/features/payments/presentation/manager/tamara_payment_cubit.dart';
import 'package:bnan_app/features/payments/presentation/manager/tamara_payment_state.dart';
import 'package:bnan_app/features/student_auth/data/models/register_flow_args_model.dart';
import 'package:bnan_app/features/student_auth/data/repo/auth_repo.dart';
import 'package:bnan_app/features/student_auth/data/repo/gulf_parent_auth_repo.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/get_curriculm_subjects_cubit/get_curriculm_subjects_cubit.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/get_grades_cubit/get_grades_cubit.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/register_cubit/register_cubit.dart';
import 'package:bnan_app/features/student_auth/presentation/views/student_registration_view.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/student_registration_widgets/tamara_verification_loading.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await CacheHelper.init();
  });

  testWidgets('Gulf payment shows SAR and no Tamara address fields', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final auth = _UnusedAuthRepo();
    final register = RegisterCubit(auth, _UnusedParentRepo())
      ..setRegisterFlowArgs(
        const RegisterFlowArgsModel(
          curriculumId: 'curriculum',
          curriculumName: 'Gulf',
          packageId: 'package',
          packageName: 'Package',
          packagePrice: '1000',
          packageCurrency: 'SAR',
          registrationMode: 'gulf',
        ),
      )
      ..nextStep()
      ..nextStep()
      ..nextStep();

    await tester.pumpWidget(_app(auth, register));
    expect(find.text(S.current.city), findsNothing);
    expect(find.text('المنطقة'), findsNothing);
    expect(find.text('العنوان'), findsNothing);
    expect(find.textContaining('SAR'), findsWidgets);
    expect(find.text(S.current.creditCard), findsNothing);
    expect(find.text(S.current.applePay), findsNothing);
    expect(find.text(S.current.tabbyTamara), findsOneWidget);
    expect(find.text(S.current.paymob), findsOneWidget);
    expect(find.text(S.current.renewalConfirmPayment), findsOneWidget);
    expect(find.text(S.current.payWithTamara), findsNothing);
    await tester.tap(find.text(S.current.paymob));
    await tester.pump();
    expect(register.selectedProvider, GulfPaymentProvider.paymob);
    expect(find.text(S.current.renewalConfirmPayment), findsOneWidget);
    expect(find.text(S.current.confirmRequest), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Egyptian registration does not show provider selection', (
    tester,
  ) async {
    final auth = _UnusedAuthRepo();
    final register = RegisterCubit(auth, _UnusedParentRepo())
      ..setRegisterFlowArgs(
        const RegisterFlowArgsModel(
          curriculumId: 'curriculum',
          curriculumName: 'Egyptian',
          packageId: 'package',
          packageName: 'Package',
          packagePrice: '1000',
          packageCurrency: 'EGP',
          registrationMode: 'egyptian',
        ),
      )
      ..nextStep()
      ..nextStep()
      ..nextStep();
    await tester.pumpWidget(_app(auth, register));
    expect(find.text(S.current.tabbyTamara), findsNothing);
    expect(find.text(S.current.paymob), findsNothing);
  });

  testWidgets('student step shows the grade hint only once', (tester) async {
    final auth = _UnusedAuthRepo();
    final register = _register(auth, steps: 2);
    await tester.pumpWidget(_app(auth, register));
    expect(find.text(S.current.selectGrade), findsOneWidget);
  });

  testWidgets('system back moves through registration steps', (tester) async {
    final auth = _UnusedAuthRepo();
    final register = _register(auth, steps: 3);
    await tester.pumpWidget(_app(auth, register));
    await tester.binding.handlePopRoute();
    await tester.pump();
    expect(register.state.currentStep, 3);
    await tester.binding.handlePopRoute();
    await tester.pump();
    expect(register.state.currentStep, 2);
    await tester.binding.handlePopRoute();
    await tester.pump();
    expect(register.state.currentStep, 1);
  });

  testWidgets('system back leaves registration from the first step', (
    tester,
  ) async {
    final auth = _UnusedAuthRepo();
    final register = _register(auth, steps: 0);
    late BuildContext hostContext;
    await tester.pumpWidget(
      _localizedApp(
        Builder(
          builder: (context) {
            hostContext = context;
            return const Text('outside-registration');
          },
        ),
      ),
    );
    Navigator.of(
      hostContext,
    ).push(MaterialPageRoute(builder: (_) => _providers(auth, register)));
    await tester.pumpAndSettle();
    expect(find.byType(StudentRegistrationView), findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byType(StudentRegistrationView), findsNothing);
  });

  testWidgets('back from step four after Tamara cancel skips verification', (
    tester,
  ) async {
    const store = PaymentDraftStore();
    await store.clear();
    await store.save(
      PaymentDraft(
        paymentId: 'payment-1',
        checkoutUrl: 'https://checkout.example.com',
        idempotencyKey: 'key-1',
        packageId: 'package',
        curriculumId: 'curriculum',
        gradeId: 'grade',
        subjectIds: const ['subject'],
        studentEmail: 'student@example.com',
        paymentStartedAt: DateTime(2026),
        lastKnownStatus: PaymentStatus.pending,
      ),
    );
    final auth = _UnusedAuthRepo();
    final register = _register(auth, steps: 3);
    final payment = TamaraPaymentCubit(
      repo: _UnusedPaymentRepo(),
      authRepo: auth,
      store: store,
    );
    await payment.restore();
    await payment.abandonCheckout();

    await tester.pumpWidget(_localizedApp(_providers(auth, register, payment)));
    expect(find.byType(TamaraVerificationLoading), findsNothing);
    final firstBack = tester.binding.handlePopRoute();
    final secondBack = tester.binding.handlePopRoute();
    await Future.wait([firstBack, secondBack]);
    await tester.pump();

    expect(register.state.currentStep, 3);
    expect(find.byType(TamaraVerificationLoading), findsNothing);
    expect(payment.state, isA<TamaraPaymentPending>());
    expect(store.read(), isNotNull);
    await payment.close();
    await store.clear();
  });
}

RegisterCubit _register(AuthRepo auth, {required int steps}) {
  final register = RegisterCubit(auth, _UnusedParentRepo())
    ..setRegisterFlowArgs(
      const RegisterFlowArgsModel(
        curriculumId: 'curriculum',
        curriculumName: 'Gulf',
        packageId: 'package',
        packageName: 'Package',
        packagePrice: '1000',
        packageCurrency: 'SAR',
        registrationMode: 'gulf',
      ),
    );
  for (var index = 0; index < steps; index++) {
    register.nextStep();
  }
  return register;
}

Widget _app(AuthRepo auth, RegisterCubit register) =>
    _localizedApp(_providers(auth, register));

Widget _providers(
  AuthRepo auth,
  RegisterCubit register, [
  TamaraPaymentCubit? payment,
]) => MultiBlocProvider(
  providers: [
    BlocProvider.value(value: register),
    BlocProvider(create: (_) => GetGradesCubit(auth)),
    BlocProvider(create: (_) => GetCurriculmSubjectsCubit(auth)),
    payment == null
        ? BlocProvider(
            create: (_) => TamaraPaymentCubit(
              repo: _UnusedPaymentRepo(),
              authRepo: auth,
              store: const PaymentDraftStore(),
            ),
          )
        : BlocProvider.value(value: payment),
  ],
  child: const StudentRegistrationView(),
);

Widget _localizedApp(Widget home) => MaterialApp(
  locale: const Locale('ar'),
  localizationsDelegates: const [
    S.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: S.delegate.supportedLocales,
  home: home,
);

class _UnusedAuthRepo implements AuthRepo {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _UnusedParentRepo implements GulfParentAuthRepo {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _UnusedPaymentRepo implements TamaraPaymentRepo {
  @override
  Future<Either<Failure, TamaraStatusResponse>> reconcile(String paymentId) =>
      Future.value(Right(_pending(paymentId)));

  @override
  Future<Either<Failure, TamaraStatusResponse>> status(
    String paymentId, {
    GulfPaymentProvider provider = GulfPaymentProvider.tamara,
  }) => Future.value(Right(_pending(paymentId)));

  TamaraStatusResponse _pending(String id) =>
      TamaraStatusResponse(paymentId: id, status: PaymentStatus.pending);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
