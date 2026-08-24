void main() {}

// import 'dart:io';

// import 'package:bnan_app/core/enums/registration_mode.dart';
// import 'package:bnan_app/core/error/failure.dart';
// import 'package:bnan_app/core/network/dependency_injection.dart';
// import 'package:bnan_app/core/session/session_manager.dart';
// import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
// import 'package:bnan_app/features/lessons_management/data/repo/gulf_schedule_repo.dart';
// import 'package:bnan_app/features/lessons_management/presentation/views/widgets/lessons_management_body.dart';
// import 'package:bnan_app/features/student_schedule/presentation/widgets/schedule_widgets/schedule_body.dart';
// import 'package:bnan_app/features/tables_management/data/models/responses/egyptian_schedule_response_model.dart';
// import 'package:bnan_app/features/tables_management/data/models/responses/egyptian_schedules_response_model.dart';
// import 'package:bnan_app/features/tables_management/data/repo/table_management_repo.dart';
// import 'package:bnan_app/features/tables_management/presentation/manager/get_egyptian_schedules_cubit/get_egyptian_schedules_cubit.dart';
// import 'package:bnan_app/features/tables_management/presentation/views/widgets/egyptian_schedules_read_only_body.dart';
// import 'package:bnan_app/generated/l10n.dart';
// import 'package:dartz/dartz.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:flutter_test/flutter_test.dart';

// import '../lessons_management/fake_gulf_schedule_repo.dart';

// void main() {
//   late _FakeEgyptianRepo egyptianRepo;
//   late FakeGulfScheduleRepo gulfRepo;

//   setUp(() async {
//     FlutterSecureStorage.setMockInitialValues({});
//     await SessionManager.instance.clearSession();
//     egyptianRepo = _FakeEgyptianRepo();
//     gulfRepo = FakeGulfScheduleRepo();
//     if (getIt.isRegistered<GetEgyptianSchedulesCubit>()) {
//       getIt.unregister<GetEgyptianSchedulesCubit>();
//     }
//     if (getIt.isRegistered<GulfScheduleRepo>()) {
//       getIt.unregister<GulfScheduleRepo>();
//     }
//     getIt.registerFactory(() => GetEgyptianSchedulesCubit(egyptianRepo));
//     getIt.registerSingleton<GulfScheduleRepo>(gulfRepo);
//   });

//   tearDown(() async {
//     await getIt.reset();
//   });

//   testWidgets('Egyptian student loads only the Egyptian schedule', (
//     tester,
//   ) async {
//     await _saveStudentMode(RegistrationMode.egyptian);
//     await _pumpSchedule(tester);

//     expect(egyptianRepo.readCalls, 1);
//     expect(gulfRepo.loadCalls, 0);
//     expect(find.byType(EgyptianSchedulesReadOnlyBody), findsOneWidget);
//   });

//   testWidgets('Gulf student loads only the Gulf schedule', (tester) async {
//     await _saveStudentMode(RegistrationMode.gulf);
//     await _pumpSchedule(tester);

//     expect(gulfRepo.loadCalls, 1);
//     expect(egyptianRepo.readCalls, 0);
//     expect(find.byType(LessonsManagementBody), findsOneWidget);
//   });

//   testWidgets('student with missing mode loads neither schedule system', (
//     tester,
//   ) async {
//     await _saveStudentMode(null);
//     await _pumpSchedule(tester);

//     expect(egyptianRepo.readCalls, 0);
//     expect(gulfRepo.loadCalls, 0);
//     expect(find.byType(NoDataWidget), findsOneWidget);
//     expect(tester.takeException(), isNull);
//   });
// }

// Future<void> _saveStudentMode(RegistrationMode? mode) {
//   return SessionManager.instance.saveSession(
//     accessToken: 'access',
//     refreshToken: 'refresh',
//     userRole: 'student',
//     registrationMode: mode,
//   );
// }

// Future<void> _pumpSchedule(WidgetTester tester) async {
//   await tester.pumpWidget(
//     MaterialApp(
//       localizationsDelegates: const [
//         S.delegate,
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//         GlobalCupertinoLocalizations.delegate,
//       ],
//       supportedLocales: S.delegate.supportedLocales,
//       home: Scaffold(body: ScheduleBody()),
//     ),
//   );
//   await tester.pumpAndSettle();
// }

// class _FakeEgyptianRepo implements TableManagementRepo {
//   int readCalls = 0;

//   @override
//   Future<Either<Failure, EgyptianSchedulesResponseModel>>
//   getMyEgyptianSchedule({String? studentId}) async {
//     readCalls++;
//     return const Right(EgyptianSchedulesResponseModel());
//   }

//   @override
//   Future<Either<Failure, EgyptianSchedulesResponseModel>> getEgyptianSchedules({
//     String? gradeId,
//   }) => throw UnimplementedError();

//   @override
//   Future<Either<Failure, EgyptianScheduleResponseModel>>
//   getEgyptianScheduleByClassroom(String classroomId) =>
//       throw UnimplementedError();

//   @override
//   Future<Either<Failure, EgyptianScheduleResponseModel>>
//   createEgyptianSchedule({
//     required String classroomId,
//     required File scheduleImage,
//   }) => throw UnimplementedError();

//   @override
//   Future<Either<Failure, void>> deleteEgyptianSchedule(String scheduleId) =>
//       throw UnimplementedError();
// }
