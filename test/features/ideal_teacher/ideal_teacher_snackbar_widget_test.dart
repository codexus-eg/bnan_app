import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/ideal_teacher/data/models/supervisor_teacher_model.dart';
import 'package:bnan_app/features/ideal_teacher/data/repos/supervisor_ideal_teacher_repo.dart';
import 'package:bnan_app/features/ideal_teacher/presentation/manager/supervisor_ideal_teacher_cubit.dart';
import 'package:bnan_app/features/ideal_teacher/presentation/views/widgets/ideal_teacher_body.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeRepo extends SupervisorIdealTeacherRepo {
  _FakeRepo({this.failSubmit = false});
  final bool failSubmit;

  @override
  Future<Either<Failure, List<SupervisorTeacherModel>>> getTeachers() async =>
      const Right([
        SupervisorTeacherModel(
          id: 't1',
          name: 'Teacher One',
          avatar: '',
          subjects: [],
          classrooms: [],
        ),
      ]);

  @override
  Future<Either<Failure, Unit>> issueIdealTeachers({
    required List<String> teacherIds,
    String? signerName,
  }) async =>
      failSubmit
          ? Left(Failure(message: 'duplicate_cert_error'))
          : const Right(unit);
}

Widget _buildApp(SupervisorIdealTeacherCubit cubit) => MaterialApp(
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: Scaffold(
        body: BlocProvider.value(
          value: cubit,
          child: const IdealTeacherBody(),
        ),
      ),
    );

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  setUp(() async {
    FlutterSecureStorage.setMockInitialValues({});
    await SessionManager.instance.saveSession(
      accessToken: 'dummy_access',
      refreshToken: 'dummy_refresh',
      userRole: 'supervisor',
      userName: 'Sup',
      userId: 's1',
    );
  });

  testWidgets('issuance shows exactly one snackbar and selection never replays it', (tester) async {
    final cubit = SupervisorIdealTeacherCubit(_FakeRepo());
    await tester.pumpWidget(_buildApp(cubit));
    await tester.pumpAndSettle();

    cubit.selectTeacher('t1');
    await cubit.submitIdealTeachers(signerName: 'Signer');
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text(S.current.idealTeacherIssuedSuccessfully), findsOneWidget);

    cubit.toggleTeacher('t1');
    await tester.pump();
    expect(find.byType(SnackBar), findsOneWidget);

    cubit.setSearchQuery('Teacher');
    await tester.pump();
    expect(find.byType(SnackBar), findsOneWidget);

    final failCubit = SupervisorIdealTeacherCubit(_FakeRepo(failSubmit: true));
    await tester.pumpWidget(_buildApp(failCubit));
    await tester.pumpAndSettle();

    failCubit.selectTeacher('t1');
    await failCubit.submitIdealTeachers();
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('duplicate_cert_error'), findsOneWidget);

    failCubit.toggleTeacher('t1');
    await tester.pump();
    expect(find.byType(SnackBar), findsOneWidget);
  });
}
