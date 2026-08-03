import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/data/models/assign_supervisor_request_model.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/data/models/get_supervisors_response_model.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/data/models/supervisor_assignments_response_model.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/data/models/unassign_supervisor_response_model.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/data/repo/supervisor_assignment_repo.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/presentation/manager/get_supervisors/get_supervisors_cubit.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/presentation/manager/supervisor_assignment_actions/supervisor_assignment_actions_cubit.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/presentation/views/supervisor_classroom_assignment_view.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows real supervisors, classrooms and empty assignments', (
    tester,
  ) async {
    await _pumpView(tester, _FakeRepo(_success));

    expect(find.text('Supervisor Assignment'), findsOneWidget);
    expect(find.text('Mahmoud Supervisor'), findsOneWidget);
    expect(find.text('Supervisor without classes'), findsOneWidget);
    expect(find.text('First classroom'), findsOneWidget);
    expect(find.text('Egyptian'), findsOneWidget);
    expect(find.text('Assign to classroom'), findsNWidgets(2));
  });

  testWidgets('empty success shows the no supervisors state', (tester) async {
    await _pumpView(
      tester,
      _FakeRepo(const Right(GetSupervisorsResponseModel())),
    );
    expect(find.byType(NoDataWidget), findsOneWidget);
    expect(find.text('No supervisors found'), findsOneWidget);
  });

  testWidgets('failure shows message and retry control', (tester) async {
    await _pumpView(tester, _FakeRepo(Left(Failure(message: 'load failed'))));
    expect(find.text('load failed'), findsOneWidget);
    expect(find.byIcon(Icons.refresh), findsOneWidget);
  });
}

Future<void> _pumpView(WidgetTester tester, _FakeRepo repo) async {
  await tester.binding.setSurfaceSize(const Size(400, 900));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => GetSupervisorsCubit(repo)..getSupervisors(),
        ),
        BlocProvider(create: (_) => SupervisorAssignmentActionsCubit(repo)),
      ],
      child: MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: const SupervisorClassroomAssignmentView(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

const _success = Right<Failure, GetSupervisorsResponseModel>(
  GetSupervisorsResponseModel(
    data: [
      SupervisorModel(
        id: 'supervisor-1',
        user: SupervisorUserModel(fullName: 'Mahmoud Supervisor'),
        curriculum: SupervisorCurriculumModel(id: 'c1', name: 'Egyptian'),
        assignments: [
          SupervisorAssignmentModel(
            classroom: SupervisorAssignmentClassroomModel(
              id: 'class-1',
              name: 'First classroom',
            ),
            curriculum: SupervisorAssignmentCurriculumModel(name: 'Egyptian'),
          ),
        ],
      ),
      SupervisorModel(
        id: 'supervisor-2',
        user: SupervisorUserModel(fullName: 'Supervisor without classes'),
      ),
    ],
  ),
);

class _FakeRepo implements SupervisorAssignmentRepo {
  const _FakeRepo(this.response);
  final Either<Failure, GetSupervisorsResponseModel> response;

  @override
  Future<Either<Failure, GetSupervisorsResponseModel>> getSupervisors() async =>
      response;

  @override
  Future<Either<Failure, SupervisorAssignmentsResponseModel>>
  assignSupervisorToClassrooms({
    required String supervisorId,
    required AssignSupervisorRequestModel request,
  }) async => const Right(SupervisorAssignmentsResponseModel());

  @override
  Future<Either<Failure, SupervisorAssignmentsResponseModel>>
  getSupervisorAssignments({required String supervisorId}) async =>
      const Right(SupervisorAssignmentsResponseModel());

  @override
  Future<Either<Failure, UnassignSupervisorResponseModel>>
  unassignSupervisorFromClassroom({
    required String supervisorId,
    required String classroomId,
  }) async => const Right(UnassignSupervisorResponseModel());
}
