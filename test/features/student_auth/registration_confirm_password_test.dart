import 'package:bnan_app/core/shared_widget/custom_password_field.dart';
import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/features/student_auth/data/repo/auth_repo.dart';
import 'package:bnan_app/features/student_auth/data/repo/gulf_parent_auth_repo.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/register_cubit/register_cubit.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/student_registration_widgets/parent_info_step_widgets/parent_info_step.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/student_registration_widgets/registration_success.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('external registration has one parent password field', (
    tester,
  ) async {
    final cubit = RegisterCubit(_AuthRepo(), _GulfParentAuthRepo());
    addTearDown(cubit.close);
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: Scaffold(
          body: BlocProvider.value(value: cubit, child: const ParentInfoStep()),
        ),
      ),
    );
    expect(find.byType(CustomPasswordField), findsOneWidget);
    expect(find.text(S.current.confirmPasswordLabel), findsNothing);
  });

  testWidgets(
    'Egyptian success explains pending approval and returns to login',
    (tester) async {
      final router = GoRouter(
        initialLocation: '/success',
        routes: [
          GoRoute(
            path: '/success',
            builder: (_, _) => const RegistrationSuccess(),
          ),
          GoRoute(
            path: Routes.logIn,
            builder: (_, _) => const Text('login-screen'),
          ),
        ],
      );
      addTearDown(router.dispose);
      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
        ),
      );
      expect(
        find.text(S.current.registrationRequestSuccessMessage),
        findsOneWidget,
      );
      await tester.tap(find.text(S.current.backToLogin));
      await tester.pumpAndSettle();
      expect(find.text('login-screen'), findsOneWidget);
    },
  );
}

class _AuthRepo implements AuthRepo {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _GulfParentAuthRepo implements GulfParentAuthRepo {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
