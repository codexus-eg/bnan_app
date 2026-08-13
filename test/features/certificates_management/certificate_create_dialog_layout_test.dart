import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/certificates_management/data/models/classroom_students_response_model.dart';
import 'package:bnan_app/features/certificates_management/data/models/student_subjects_response_model.dart';
import 'package:bnan_app/features/certificates_management/data/repo/certificates_management_repo.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/create_monthly_certificate_cubit/create_monthly_certificate_cubit.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/get_classroom_students_cubit/get_classroom_students_cubit.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/get_monthly_certificates_cubit/get_monthly_certificates_cubit.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/get_student_subjects_cubit/get_student_subjects_cubit.dart';
import 'package:bnan_app/features/certificates_management/presentation/views/dialogs/certificate_dialog.dart';
import 'package:bnan_app/features/supervisor_management/data/models/get_supervisor_classrooms_response_model.dart';
import 'package:bnan_app/features/supervisor_management/data/models/supervisor_classroom_model.dart';
import 'package:bnan_app/features/supervisor_management/data/repo/supervisor_management_repo.dart';
import 'package:bnan_app/features/supervisor_management/presentation/manager/get_supervisor_classrooms/get_supervisor_classrooms_cubit.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'create dialog remains scrollable above a small-screen keyboard',
    (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(const _TestApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select classroom'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Class A').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Select student'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Student One').last);
      await tester.pumpAndSettle();

      tester.view.viewInsets = const FakeViewPadding(bottom: 280);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Save'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Subject 8'),
        100,
        scrollable: find.byKey(const Key('certificateCreateFieldsScroll')),
      );
      expect(find.text('Subject 8'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}

class _TestApp extends StatelessWidget {
  const _TestApp();

  @override
  Widget build(BuildContext context) {
    final certificatesRepo = _CertificatesRepo();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              GetSupervisorClassroomsCubit(_SupervisorRepo())
                ..getMyClassrooms(),
        ),
        BlocProvider(
          create: (_) => GetClassroomStudentsCubit(certificatesRepo),
        ),
        BlocProvider(create: (_) => GetStudentSubjectsCubit(certificatesRepo)),
        BlocProvider(
          create: (_) => CreateMonthlyCertificateCubit(certificatesRepo),
        ),
        BlocProvider(
          create: (_) => GetMonthlyCertificatesCubit(certificatesRepo),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: const Scaffold(body: CertificateDialog()),
      ),
    );
  }
}

class _SupervisorRepo implements SupervisorManagementRepo {
  @override
  Future<Either<Failure, GetSupervisorClassroomsResponseModel>>
  getMyClassrooms() async => const Right(
    GetSupervisorClassroomsResponseModel(
      success: true,
      results: 1,
      data: [SupervisorClassroomModel(id: 'class-a', name: 'Class A')],
    ),
  );
}

class _CertificatesRepo implements CertificatesManagementRepo {
  @override
  Future<Either<Failure, ClassroomStudentsResponseModel>> getClassroomStudents({
    required String classroomId,
  }) async => const Right(
    ClassroomStudentsResponseModel(
      success: true,
      count: 1,
      data: [ClassroomStudentModel(id: 'student-1', fullName: 'Student One')],
    ),
  );

  @override
  Future<Either<Failure, StudentSubjectsResponseModel>> getStudentSubjects({
    required String classroomId,
    required String studentId,
  }) async => Right(
    StudentSubjectsResponseModel(
      success: true,
      count: 8,
      data: List.generate(
        8,
        (index) => StudentSubjectModel(
          id: 'subject-${index + 1}',
          name: 'Subject ${index + 1}',
        ),
      ),
    ),
  );

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
