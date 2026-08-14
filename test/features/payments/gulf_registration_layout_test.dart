import 'package:bnan_app/core/cache/cache_helper.dart';
import 'package:bnan_app/features/payments/data/payment_draft_store.dart';
import 'package:bnan_app/features/payments/data/repo/tamara_payment_repo.dart';
import 'package:bnan_app/features/payments/presentation/manager/tamara_payment_cubit.dart';
import 'package:bnan_app/features/student_auth/data/models/register_flow_args_model.dart';
import 'package:bnan_app/features/student_auth/data/repo/auth_repo.dart';
import 'package:bnan_app/features/student_auth/data/repo/gulf_parent_auth_repo.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/get_curriculm_subjects_cubit/get_curriculm_subjects_cubit.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/get_grades_cubit/get_grades_cubit.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/register_cubit/register_cubit.dart';
import 'package:bnan_app/features/student_auth/presentation/views/student_registration_view.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Gulf payment shows SAR and no Tamara address fields', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    await CacheHelper.init();
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
    expect(find.textContaining('ريال'), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}

Widget _app(AuthRepo auth, RegisterCubit register) => MultiBlocProvider(
  providers: [
    BlocProvider.value(value: register),
    BlocProvider(create: (_) => GetGradesCubit(auth)),
    BlocProvider(create: (_) => GetCurriculmSubjectsCubit(auth)),
    BlocProvider(
      create: (_) => TamaraPaymentCubit(
        repo: _UnusedPaymentRepo(),
        authRepo: auth,
        store: const PaymentDraftStore(),
      ),
    ),
  ],
  child: MaterialApp(
    locale: const Locale('ar'),
    localizationsDelegates: const [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: S.delegate.supportedLocales,
    home: const StudentRegistrationView(),
  ),
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
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
