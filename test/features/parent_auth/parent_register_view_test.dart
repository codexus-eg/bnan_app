import 'dart:async';

import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/features/parent_auth/data/models/parent_register_request_model.dart';
import 'package:bnan_app/features/parent_auth/data/models/parent_register_response_model.dart';
import 'package:bnan_app/features/parent_auth/data/models/parent_register_user_model.dart';
import 'package:bnan_app/features/parent_auth/data/repo/parent_auth_repo.dart';
import 'package:bnan_app/features/parent_auth/presentation/manager/parent_register_cubit/parent_register_cubit.dart';
import 'package:bnan_app/features/parent_auth/presentation/views/parent_register_view.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('keeps the existing fields and validates before API calls', (
    tester,
  ) async {
    final repo = _ImmediateRepo(const Right(_response));
    await tester.pumpWidget(_localizedApp(repo));
    final s = S.of(tester.element(find.byType(ParentRegisterView)));

    expect(find.text(s.parentRegistrationForm), findsOneWidget);
    expect(find.text(s.passwordWillBeUsed), findsNothing);
    final fields = tester
        .widgetList<CustomTextField>(find.byType(CustomTextField))
        .toList();
    expect(fields, hasLength(5));
    expect(fields[3].isRequired, isFalse);
    expect(fields[4].obscureText, isTrue);

    await tester.tap(find.byIcon(Icons.visibility_off_outlined));
    await tester.pump();
    expect(
      tester
          .widgetList<CustomTextField>(find.byType(CustomTextField))
          .last
          .obscureText,
      isFalse,
    );

    await _tapNext(tester);
    expect(repo.calls, 0);
    expect(find.text(s.nameCannotBeEmpty), findsOneWidget);
  });

  testWidgets('valid submit calls once and disables the loading button', (
    tester,
  ) async {
    final repo = _PendingRepo();
    await tester.pumpWidget(_localizedApp(repo));
    await _fillValidForm(tester);
    await _tapNext(tester);

    expect(repo.calls, 1);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await _tapNext(tester);
    expect(repo.calls, 1);

    repo.completer.complete(Left(Failure(message: 'failed')));
    await tester.pumpAndSettle();
  });

  testWidgets('success navigates directly to parent home', (tester) async {
    final repo = _ImmediateRepo(const Right(_response));
    final router = GoRouter(
      initialLocation: '/parent-registration',
      routes: [
        GoRoute(
          path: '/parent-registration',
          builder: (_, _) => BlocProvider(
            create: (_) => ParentRegisterCubit(repo),
            child: const ParentRegisterView(),
          ),
        ),
        GoRoute(
          path: '/parentHome',
          builder: (_, _) => const Scaffold(key: Key('parent-home')),
        ),
      ],
    );
    await tester.pumpWidget(_localizedRouterApp(router));
    await _fillValidForm(tester);
    await _tapNext(tester);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('parent-home')), findsOneWidget);
    expect(repo.calls, 1);
  });
}

Widget _localizedApp(ParentAuthRepo repo) {
  return MaterialApp(
    locale: const Locale('ar'),
    localizationsDelegates: _delegates,
    supportedLocales: S.delegate.supportedLocales,
    home: BlocProvider(
      create: (_) => ParentRegisterCubit(repo),
      child: const ParentRegisterView(),
    ),
  );
}

Widget _localizedRouterApp(GoRouter router) => MaterialApp.router(
  locale: const Locale('ar'),
  localizationsDelegates: _delegates,
  supportedLocales: S.delegate.supportedLocales,
  routerConfig: router,
);

const _delegates = <LocalizationsDelegate<dynamic>>[
  S.delegate,
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];

Future<void> _fillValidForm(WidgetTester tester) async {
  final fields = find.byType(TextFormField);
  await tester.enterText(fields.at(0), 'Parent Name');
  await tester.enterText(fields.at(1), 'parent@bnan.edu');
  await tester.enterText(fields.at(2), '206566456');
  await tester.enterText(fields.at(3), '+201000000000');
  await tester.enterText(fields.at(4), '12345678');
}

Future<void> _tapNext(WidgetTester tester) async {
  final next = find.byType(CustomAppButton);
  await tester.ensureVisible(next);
  await tester.tap(next);
  await tester.pump();
}

const _response = ParentRegisterResponseModel(
  success: true,
  token: 'token',
  data: ParentRegisterUserModel(
    id: 'parent-1',
    fullName: 'Parent Name',
    email: 'parent@bnan.edu',
    role: 'parent',
    status: 'active',
    createdAt: '',
    updatedAt: '',
  ),
);

class _ImmediateRepo implements ParentAuthRepo {
  _ImmediateRepo(this.result);
  final Either<Failure, ParentRegisterResponseModel> result;
  int calls = 0;

  @override
  Future<Either<Failure, ParentRegisterResponseModel>> registerParent(
    ParentRegisterRequestModel request,
  ) async {
    calls++;
    return result;
  }
}

class _PendingRepo implements ParentAuthRepo {
  final completer = Completer<Either<Failure, ParentRegisterResponseModel>>();
  int calls = 0;

  @override
  Future<Either<Failure, ParentRegisterResponseModel>> registerParent(
    ParentRegisterRequestModel request,
  ) {
    calls++;
    return completer.future;
  }
}
