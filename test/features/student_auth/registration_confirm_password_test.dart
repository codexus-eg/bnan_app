import 'package:bnan_app/core/shared_widget/custom_password_field.dart';
import 'package:bnan_app/features/student_auth/data/repo/auth_repo.dart';
import 'package:bnan_app/features/student_auth/data/repo/gulf_parent_auth_repo.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/register_cubit/register_cubit.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/student_registration_widgets/parent_info_step_widgets/parent_info_step.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

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
}

class _AuthRepo implements AuthRepo {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _GulfParentAuthRepo implements GulfParentAuthRepo {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
