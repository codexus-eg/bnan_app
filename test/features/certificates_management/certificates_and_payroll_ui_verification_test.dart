import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/features/certificates_management/data/models/teacher_certificate_model.dart';
import 'package:bnan_app/features/certificates_management/data/models/teacher_certificates_response_model.dart';
import 'package:bnan_app/features/certificates_management/data/repo/certificates_management_repo.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/teacher_certificates_cubit/teacher_certificates_cubit.dart';
import 'package:bnan_app/features/certificates_management/presentation/views/dialogs/teacher_certificate_issue_dialog.dart';
import 'package:bnan_app/features/certificates_management/presentation/views/widgets/certificate_action_button.dart';
import 'package:bnan_app/features/certificates_management/presentation/views/widgets/teacher_certificate_card.dart';
import 'package:bnan_app/features/ideal_teacher/data/models/supervisor_teacher_model.dart';
import 'package:bnan_app/features/ideal_teacher/data/repos/supervisor_ideal_teacher_repo.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/widgets/payroll_status_badge.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const testCertDraft = TeacherCertificateModel(
    id: 'cert_draft_1',
    certificateNumber: 'CERT-101',
    certificateType: 'general_teacher',
    teacherName: 'سارة محمد',
    recipientName: 'أ/ سارة محمد إبراهيم (مخصص)',
    status: 'draft',
    period: null,
    previewImagePath: '',
    pdfPath: '',
    issuedAt: null,
  );

  group('Check 2: Supervisor access to certificate draft creation form', () {
    testWidgets('form displays custom recipientName field', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final fakeCertRepo = _FakeCertRepo();
      final fakeTeachRepo = _FakeTeachRepo(teachers: [
        const SupervisorTeacherModel(
          id: 'teach_1',
          name: 'سارة محمد',
          avatar: '',
          subjects: ['رياضيات'],
          classrooms: [],
        ),
      ]);
      final cubit = TeacherCertificatesCubit(
        fakeCertRepo,
        fakeTeachRepo,
        isAdmin: false,
      );

      await tester.pumpWidget(
        _wrapWithProviders(
          cubit: cubit,
          child: const TeacherCertificateIssueDialog(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CustomTextField), findsOneWidget);
      await tester.enterText(
        find.byType(CustomTextField),
        'أ/ سارة محمد إبراهيم (الاسم المطلوب)',
      );
      await tester.pump();
      expect(find.text('أ/ سارة محمد إبراهيم (الاسم المطلوب)'), findsOneWidget);

      await cubit.close();
    });
  });

  group('Check 3: Admin certificate draft review and Issue action', () {
    testWidgets('Admin card displays draft status and Issue action',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      bool issued = false;
      await tester.pumpWidget(
        _wrapWithProviders(
          child: TeacherCertificateCard(
            certificate: testCertDraft,
            isAdmin: true,
            onIssue: () => issued = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('أ/ سارة محمد إبراهيم (مخصص)'), findsOneWidget);
      expect(find.text('مسودة'), findsOneWidget);

      final issueButton = find.widgetWithText(
        CertificateActionButton,
        'إصدار الشهادة',
      );
      expect(issueButton, findsOneWidget);
      await tester.tap(issueButton);
      expect(issued, isTrue);
    });

    testWidgets('Supervisor view hides Issue action button', (tester) async {
      await tester.pumpWidget(
        _wrapWithProviders(
          child: const TeacherCertificateCard(
            certificate: testCertDraft,
            isAdmin: false,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.widgetWithText(CertificateActionButton, 'إصدار الشهادة'),
        findsNothing,
      );
      expect(find.text('معاينة'), findsOneWidget);
    });
  });

  group('Check 4: Payroll statement statuses and role visibility', () {
    testWidgets('renders badges for all documented statement statuses',
        (tester) async {
      await tester.pumpWidget(
        _wrapWithProviders(
          child: const Column(
            children: [
              PayrollStatusBadge(status: 'draft'),
              PayrollStatusBadge(status: 'sent'),
              PayrollStatusBadge(status: 'payment_pending'),
              PayrollStatusBadge(status: 'paid'),
              PayrollStatusBadge(status: 'cancelled'),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(PayrollStatusBadge), findsNWidgets(5));
      expect(find.text('مسودة'), findsOneWidget); // draft
      expect(find.text('تم الإرسال'), findsOneWidget); // sent
      expect(find.text('بانتظار الدفع'), findsOneWidget); // payment_pending
      expect(find.text('مدفوع'), findsOneWidget); // paid
      expect(find.text('ملغي'), findsOneWidget); // cancelled
    });
  });
}

Widget _wrapWithProviders({
  required Widget child,
  TeacherCertificatesCubit? cubit,
}) {
  return MaterialApp(
    locale: const Locale('ar'),
    localizationsDelegates: const [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: S.delegate.supportedLocales,
    home: Scaffold(
      body: cubit != null
          ? BlocProvider.value(value: cubit, child: child)
          : child,
    ),
  );
}

class _FakeCertRepo implements CertificatesManagementRepo {
  @override
  Future<Either<Failure, TeacherCertificateModel>>
      createTeacherCertificateDraft({
    required String teacherId,
    required String recipientName,
  }) async =>
          const Right(TeacherCertificateModel(
            id: 'c1',
            certificateNumber: '',
            certificateType: 'general_teacher',
            teacherName: 'T',
            recipientName: 'R',
            status: 'draft',
            period: null,
            previewImagePath: '',
            pdfPath: '',
            issuedAt: null,
          ));

  @override
  Future<Either<Failure, TeacherCertificateModel>>
      issueGeneralTeacherCertificate({required String certificateId}) async =>
          const Right(TeacherCertificateModel(
            id: 'c1',
            certificateNumber: '',
            certificateType: 'general_teacher',
            teacherName: 'T',
            recipientName: 'R',
            status: 'issued',
            period: null,
            previewImagePath: '',
            pdfPath: '',
            issuedAt: null,
          ));

  @override
  Future<Either<Failure, TeacherCertificatesResponseModel>>
      getAdminCertificates({
    String certificateType = 'general_teacher',
    String? status,
    int page = 1,
    int limit = 20,
  }) async =>
          throw UnimplementedError();

  @override
  Future<Either<Failure, TeacherCertificatesResponseModel>>
      getMyTeacherCertificates() async => throw UnimplementedError();

  @override
  Future<Either<Failure, TeacherCertificatesResponseModel>>
      getTeacherCertificates({
    required int page,
    int limit = 20,
    String? status,
    String? teacherId,
    String? certificateType,
  }) async =>
          throw UnimplementedError();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeTeachRepo extends SupervisorIdealTeacherRepo {
  _FakeTeachRepo({this.teachers = const []});
  final List<SupervisorTeacherModel> teachers;

  @override
  Future<Either<Failure, List<SupervisorTeacherModel>>> getTeachers() async =>
      Right(teachers);

  @override
  Future<Either<Failure, Unit>> issueIdealTeachers({
    required List<String> teacherIds,
    String? signerName,
  }) async =>
      const Right(unit);
}
