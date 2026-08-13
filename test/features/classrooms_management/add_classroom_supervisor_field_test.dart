import 'dart:async';

import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/classrooms_management/presentation/views/widgets/dialogs/add_classroom_supervisor_field.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/data/models/get_supervisors_response_model.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/data/repo/supervisor_assignment_repo.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/presentation/manager/get_supervisors/get_supervisors_cubit.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('requires a supervisor and displays backend names', (
    tester,
  ) async {
    final key = GlobalKey<FormState>();
    final cubit = GetSupervisorsCubit(_SupervisorRepo())..getSupervisors();
    String? selected;
    await tester.pumpWidget(_app(cubit, key, (value) => selected = value));
    await tester.pumpAndSettle();

    expect(key.currentState!.validate(), isFalse);
    expect(find.text('Supervisor is required'), findsOneWidget);
    await tester.tap(find.byType(DropdownButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mahmoud Supervisor').last);
    await tester.pumpAndSettle();

    expect(selected, 'supervisor-1');
    expect(key.currentState!.validate(), isTrue);
  });

  testWidgets('shows localized empty supervisors state', (tester) async {
    final cubit = GetSupervisorsCubit(_SupervisorRepo(empty: true))
      ..getSupervisors();
    await tester.pumpWidget(_app(cubit, GlobalKey<FormState>(), (_) {}));
    await tester.pumpAndSettle();
    expect(find.text('No supervisors found'), findsOneWidget);
  });

  testWidgets('shows loading while supervisors request is pending', (
    tester,
  ) async {
    final repo = _SupervisorRepo(pending: Completer());
    final cubit = GetSupervisorsCubit(repo)..getSupervisors();
    await tester.pumpWidget(_app(cubit, GlobalKey<FormState>(), (_) {}));
    await tester.pump();

    expect(find.text('Loading...'), findsOneWidget);
    repo.pending!.complete(const Right(GetSupervisorsResponseModel()));
  });

  testWidgets('shows backend error and retry action', (tester) async {
    final cubit = GetSupervisorsCubit(
      const _SupervisorRepo(failureMessage: 'Backend unavailable'),
    )..getSupervisors();
    await tester.pumpWidget(_app(cubit, GlobalKey<FormState>(), (_) {}));
    await tester.pumpAndSettle();

    expect(find.text('Backend unavailable'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });
}

Widget _app(
  GetSupervisorsCubit cubit,
  GlobalKey<FormState> key,
  ValueChanged<String?> onChanged,
) => MaterialApp(
  localizationsDelegates: const [
    S.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: S.delegate.supportedLocales,
  locale: const Locale('en'),
  home: Scaffold(
    body: BlocProvider.value(
      value: cubit,
      child: Form(
        key: key,
        child: AddClassroomSupervisorField(value: null, onChanged: onChanged),
      ),
    ),
  ),
);

class _SupervisorRepo implements SupervisorAssignmentRepo {
  const _SupervisorRepo({
    this.empty = false,
    this.failureMessage,
    this.pending,
  });
  final bool empty;
  final String? failureMessage;
  final Completer<Either<Failure, GetSupervisorsResponseModel>>? pending;

  @override
  Future<Either<Failure, GetSupervisorsResponseModel>> getSupervisors() async {
    if (pending != null) return pending!.future;
    if (failureMessage != null) {
      return Left(Failure(message: failureMessage!));
    }
    return Right(
      GetSupervisorsResponseModel(
        data: empty
            ? const []
            : const [
                SupervisorModel(
                  id: 'supervisor-1',
                  user: SupervisorUserModel(fullName: 'Mahmoud Supervisor'),
                ),
              ],
      ),
    );
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
