import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/features/payments/presentation/views/payment_checkout_launcher.dart';
import 'package:bnan_app/features/payments/presentation/views/paymob_checkout_view.dart';
import 'package:bnan_app/features/payments/presentation/views/tamara_sdk_checkout_view.dart';
import 'package:bnan_app/features/student_subject_requests/presentation/manager/student_subject_requests_cubit.dart';
import 'package:bnan_app/features/student_subject_requests/presentation/manager/subject_request_payment_cubit.dart';
import 'package:bnan_app/features/student_subject_requests/presentation/views/student_subject_requests_view.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'payment_flow_fixture.dart';

export 'payment_flow_fixture.dart';
export 'package:bnan_app/generated/l10n.dart';
export 'package:bnan_app/features/student_subject_requests/presentation/views/student_subject_requests_view.dart';
export 'package:bnan_app/features/payments/presentation/views/tamara_sdk_checkout_view.dart';
export 'package:flutter/material.dart';
export 'package:flutter_test/flutter_test.dart';

class PaymentFlowHarness extends PaymentFlowFixture {
  PaymentFlowHarness({super.mode});
  late GoRouter router;
  int launches = 0;
  GulfPaymentProvider? launchedProvider;

  Future<void> mount(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1000, 1800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) => const Scaffold(body: Text('Home')),
          routes: [
            GoRoute(
              path: 'request',
              builder: (_, _) =>
                  StudentSubjectRequestsView(checkoutLauncher: launch),
            ),
          ],
        ),
      ],
    );
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      router.dispose();
      await close();
    });
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<StudentSubjectRequestsCubit>.value(value: request),
          BlocProvider<SubjectRequestPaymentCubit>.value(value: payment),
        ],
        child: MaterialApp.router(
          routerConfig: router,
          locale: const Locale('en'),
          supportedLocales: S.delegate.supportedLocales,
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();
    router.push('/request');
    await tester.pumpAndSettle();
    await request.load();
    await tester.pumpAndSettle();
    request.selectSubject('enabled');
    request.selectPackage('valid');
    await tester.pumpAndSettle();
    final notes = find.byWidgetPredicate(
      (widget) =>
          widget is CustomTextField &&
          widget.label == S.current.theRequiredLesson,
    );
    await tester.enterText(
      find.descendant(of: notes, matching: find.byType(TextFormField)),
      'Algebra lesson',
    );
    await tester.pumpAndSettle();
    expect(request.state.notes, 'Algebra lesson');
  }

  Future<PaymentCheckoutLaunchResult> launch({
    required BuildContext context,
    required GulfPaymentProvider provider,
    required String checkoutUrl,
    Stream<bool>? completionStream,
    bool Function()? isCompleted,
  }) async {
    launches++;
    launchedProvider = provider;
    final outcome = await Navigator.of(context).push<TamaraSdkOutcome>(
      MaterialPageRoute(
        builder: (gatewayContext) => Scaffold(
          body: Text('Gateway: ${provider.name}'),
          appBar: AppBar(
            actions: [
              TextButton(
                onPressed: () =>
                    Navigator.of(gatewayContext).pop(TamaraSdkOutcome.cancel),
                child: const Text('Close gateway'),
              ),
            ],
          ),
        ),
      ),
    );
    return PaymentCheckoutLaunchResult(
      provider: provider,
      opened: true,
      tamaraOutcome: provider == GulfPaymentProvider.tamara ? outcome : null,
      paymobOutcome: provider == GulfPaymentProvider.paymob
          ? PaymobCheckoutOutcome.closed
          : null,
    );
  }

  Future<void> open(WidgetTester tester, GulfPaymentProvider provider) async {
    repo.checkoutResults.add(
      Right(paymentResult(SubjectRequestPaymentStatus.pending)),
    );
    final option = find.text(
      provider == GulfPaymentProvider.paymob
          ? S.current.paymob
          : S.current.tabbyTamara,
    );
    await tester.ensureVisible(option);
    await tester.tap(option);
    final submit = find.text(S.current.renewalConfirmPayment);
    await tester.ensureVisible(submit);
    await tester.tap(submit);
    await tester.pumpAndSettle();
    expect(find.text('Gateway: ${provider.name}'), findsOneWidget);
    expect(launchedProvider, provider);
    expect(repo.lastPayload?.notes, 'Algebra lesson');
  }

  Future<void> dismiss(
    WidgetTester tester, {
    bool button = false,
    TamaraSdkOutcome? outcome,
  }) async {
    if (outcome != null) {
      Navigator.of(
        tester.element(find.textContaining('Gateway:')),
      ).pop(outcome);
    } else if (button) {
      await tester.tap(find.text('Close gateway'));
    } else {
      await tester.binding.handlePopRoute();
    }
    await tester.pumpAndSettle();
  }

  void expectForm() {
    expect(find.byType(StudentSubjectRequestsView), findsOneWidget);
    expect(find.text('Algebra lesson'), findsOneWidget);
    expect(request.state.selectedSubjectId, 'enabled');
    expect(request.state.selectedPackageId, 'valid');
    expect(request.state.notes, 'Algebra lesson');
    expect(find.text('Home'), findsNothing);
  }
}
