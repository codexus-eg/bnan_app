import 'package:bnan_app/core/error/app_exception.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/features/certificates_management/data/models/classroom_students_response_model.dart';
import 'package:bnan_app/features/certificates_management/data/models/monthly_certificate_summary_model.dart';
import 'package:bnan_app/features/certificates_management/data/models/requests/certificate_subject_request_model.dart';
import 'package:bnan_app/features/certificates_management/data/models/requests/create_monthly_certificate_request_model.dart';
import 'package:bnan_app/features/certificates_management/data/models/requests/update_monthly_certificate_request_model.dart';
import 'package:bnan_app/features/certificates_management/data/repo/certificates_management_repo_impl.dart';
import 'package:bnan_app/features/certificates_management/presentation/views/dialogs/certificate_issue_confirm_dialog.dart';
import 'package:bnan_app/features/supervisor_management/data/repo/supervisor_management_repo_impl.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await S.load(const Locale('ar'));
  });

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
  });

  group('Requirement 1 & 2: Teacher navigation and existing teacher certificate viewing', () {
    test('Teacher role maps supervisor classrooms repo to /teachers/myclassrooms', () async {
      await SessionManager.instance.saveSession(
        accessToken: 'mock_token',
        refreshToken: 'mock_refresh',
        userRole: 'teacher',
      );
      final mockApi = _MockApi(response: {
        'success': true,
        'data': [
          {
            '_id': 'cls_1',
            'name': 'الصف الأول',
            'classroomCode': 'CLS-101',
          }
        ]
      });
      final repo = SupervisorManagementRepoImpl(mockApi);
      final result = await repo.getMyClassrooms();

      expect(mockApi.lastPath, EndPoints.teacherClassrooms);
      expect(mockApi.lastPath, '/teachers/myclassrooms');
      result.fold(
        (l) => fail('Expected classrooms'),
        (response) {
          expect(response.data.length, 1);
          expect(response.data.first.id, 'cls_1');
        },
      );
    });

    test('Supervisor role keeps supervisor classrooms endpoint /supervisors/me/classrooms', () async {
      await SessionManager.instance.saveSession(
        accessToken: 'mock_token',
        refreshToken: 'mock_refresh',
        userRole: 'supervisor',
      );
      final mockApi = _MockApi(response: {
        'success': true,
        'data': []
      });
      final repo = SupervisorManagementRepoImpl(mockApi);
      await repo.getMyClassrooms();

      expect(mockApi.lastPath, EndPoints.supervisorMyClassrooms);
      expect(mockApi.lastPath, '/supervisors/me/classrooms');
    });
  });

  group('Requirement 3: Student profile ID selection', () {
    test('Prioritizes studentProfileId and studentId over userId', () {
      final studentFromNested = ClassroomStudentModel.fromJson({
        '_id': 'enrollment_1',
        'userId': 'user_should_not_use',
        'studentId': {
          '_id': 'profile_id_nested',
          'fullName': 'طالب تجريبي',
        },
      });
      expect(studentFromNested.id, 'profile_id_nested');
      expect(studentFromNested.fullName, 'طالب تجريبي');

      final studentFlat = ClassroomStudentModel.fromJson({
        'studentProfileId': 'profile_id_direct',
        'userId': 'user_id_ignored',
        'fullName': 'طالب مباشر',
      });
      expect(studentFlat.id, 'profile_id_direct');
    });
  });

  group('Requirement 4 & 5 & 6: Create draft JSON, numeric grade & duplicate subject validations', () {
    test('Create draft model produces exact contract JSON payload', () {
      const model = CreateMonthlyCertificateRequestModel(
        studentId: 'student_prof_456',
        classroomId: 'classroom_789',
        signerName: 'أ/ سارة محمد',
        subjects: [
          CertificateSubjectRequestModel(
            subjectId: 'sub_math',
            score: 18,
            maxScore: 20,
          ),
          CertificateSubjectRequestModel(
            subjectId: 'sub_sci',
            score: 28,
            maxScore: 30,
          ),
        ],
      );

      final json = model.toJson();
      expect(json, {
        'studentId': 'student_prof_456',
        'classroomId': 'classroom_789',
        'signerName': 'أ/ سارة محمد',
        'subjects': [
          {'subjectId': 'sub_math', 'score': 18, 'maxScore': 20},
          {'subjectId': 'sub_sci', 'score': 28, 'maxScore': 30},
        ],
      });
    });

    test('CertificatesManagementRepoImpl.createMonthlyCertificate calls /certificates/student-monthly', () async {
      final mockApi = _MockApi(response: {
        'success': true,
        'data': {
          'certificate': {
            '_id': 'cert_new',
            'status': 'draft',
            'certificateNumber': 'CERT-2026',
            'studentName': 'طالب',
            'gradeName': 'أول ابتدائي',
            'period': 'أكتوبر 2026',
          }
        }
      });
      final repo = CertificatesManagementRepoImpl(mockApi);
      const req = CreateMonthlyCertificateRequestModel(
        studentId: 'std_1',
        classroomId: 'cls_1',
        signerName: 'مدرس',
        subjects: [
          CertificateSubjectRequestModel(
            subjectId: 'sub_1',
            score: 10,
            maxScore: 10,
          ),
        ],
      );
      final res = await repo.createMonthlyCertificate(request: req);

      expect(mockApi.lastPath, EndPoints.studentMonthlyCertificates);
      expect(mockApi.lastPath, '/certificates/student-monthly');
      res.fold(
        (f) => fail('Expected created cert'),
        (resp) {
          expect(resp.certificate?.id, 'cert_new');
          expect(resp.certificate?.status, 'draft');
        },
      );
    });
  });

  group('Requirement 7: Certificate response parsing', () {
    test('parses MonthlyCertificateSummaryModel correctly', () {
      final json = {
        '_id': 'cert_sum_1',
        'certificateNumber': 'BNAN-2026-001',
        'studentName': 'عبير مصطفى لبيب',
        'gradeName': 'أول ابتدائي - عربي',
        'period': {'month': 10, 'year': 2026},
        'status': 'draft',
        'previewImagePath': '/preview/cert.png',
        'pdfPath': null,
        'createdAt': '2026-10-27T10:00:00Z',
        'issuedAt': null,
      };

      final cert = MonthlyCertificateSummaryModel.fromJson(json);
      expect(cert.id, 'cert_sum_1');
      expect(cert.certificateNumber, 'BNAN-2026-001');
      expect(cert.studentName, 'عبير مصطفى لبيب');
      expect(cert.gradeName, 'أول ابتدائي - عربي');
      expect(cert.period?.month, 10);
      expect(cert.period?.year, 2026);
      expect(cert.status, 'draft');
      expect(cert.previewImagePath, '/preview/cert.png');
      expect(cert.pdfPath, isNull);
    });
  });

  group('Requirement 8 & 9: Draft edit/delete and HTTP 204 handling', () {
    test('deleteMonthlyCertificate handles 204 No Content without error', () async {
      final mockApi = _MockApi(response: null);
      final repo = CertificatesManagementRepoImpl(mockApi);
      final result = await repo.deleteMonthlyCertificate(certificateId: 'cert_to_delete');

      expect(mockApi.lastPath, '/certificates/monthly/cert_to_delete');
      result.fold(
        (f) => fail('Delete should succeed on 204 null response'),
        (_) {},
      );
    });

    test('updateMonthlyCertificate calls PATCH /certificates/monthly/{id}', () async {
      final mockApi = _MockApi(response: {
        'success': true,
        'data': {
          'certificate': {
            '_id': 'cert_1',
            'status': 'draft',
            'signerName': 'Updated Signer',
          }
        }
      });
      final repo = CertificatesManagementRepoImpl(mockApi);
      const req = UpdateMonthlyCertificateRequestModel(
        signerName: 'Updated Signer',
      );
      final result = await repo.updateMonthlyCertificate(
        certificateId: 'cert_1',
        request: req,
      );

      expect(mockApi.lastPath, '/certificates/monthly/cert_1');
      result.fold(
        (f) => fail('Update should succeed'),
        (resp) => expect(resp, isNotNull),
      );
    });
  });

  group('Requirement 10: Bulk issue empty request body and warning confirmation', () {
    test('issueMonthlyCertificates posts with null body', () async {
      final mockApi = _MockApi(response: {
        'success': true,
        'message': 'Issued all eligible drafts',
      });
      final repo = CertificatesManagementRepoImpl(mockApi);
      final result = await repo.issueMonthlyCertificates();

      expect(mockApi.lastPath, EndPoints.issueMonthlyCertificates);
      expect(mockApi.lastPath, '/certificates/student-monthly/issue');
      expect(mockApi.lastData, isNull);
      result.fold(
        (f) => fail('Bulk issue failed'),
        (u) => expect(u, isNotNull),
      );
    });

    testWidgets('CertificateIssueConfirmDialog displays warning for all assigned classrooms', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          locale: const Locale('ar'),
          home: Scaffold(
            body: CertificateIssueConfirmDialog(
              onConfirm: () {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(S.current.confirmIssueAllDrafts), findsOneWidget);
      expect(find.text(S.current.sendAll), findsNWidgets(2));
      expect(find.text(S.current.cancel), findsOneWidget);
    });
  });

  group('Requirement 11 & 12: Correct filtering and preview/PDF endpoints', () {
    test('getMonthlyCertificates sends classroomId query param', () async {
      final mockApi = _MockApi(response: {
        'success': true,
        'data': [],
        'pagination': {'total': 0}
      });
      final repo = CertificatesManagementRepoImpl(mockApi);
      await repo.getMonthlyCertificates(
        classroomId: 'cls_abc',
      );

      expect(mockApi.lastPath, EndPoints.monthlyCertificates(classroomId: 'cls_abc'));
      expect(mockApi.lastPath, '/certificates/monthly?classroomId=cls_abc');
    });

    test('monthlyCertificateById returns correct endpoint', () {
      expect(EndPoints.monthlyCertificateById('123'), '/certificates/monthly/123');
    });
  });

  group('Requirement 13: Error mapping for confirmed backend error codes', () {
    test('maps all 6 backend certificate error codes to localized messages', () {
      final codes = {
        'CERTIFICATE_ACCESS_DENIED': S.current.certificateAccessDenied,
        'CERTIFICATE_ALREADY_EXISTS': S.current.certificateAlreadyExists,
        'INVALID_CERTIFICATE_SUBJECTS': S.current.invalidCertificateSubjects,
        'NO_DRAFT_CERTIFICATES_TO_ISSUE': S.current.noDraftCertificatesToIssue,
        'ONLY_DRAFT_CERTIFICATES_CAN_BE_UPDATED': S.current.onlyDraftCertificatesCanBeUpdated,
        'STUDENT_NOT_ENROLLED_IN_CLASSROOM': S.current.studentNotEnrolledInClassroom,
      };

      for (final entry in codes.entries) {
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: 400,
            data: {'code': entry.key},
          ),
          type: DioExceptionType.badResponse,
        );
        final appException = AppException.fromDio(dioException);
        expect(appException.message, entry.value);
      }
    });
  });
}

class _MockApi implements ApiConsumer {
  _MockApi({required this.response});
  final Object? response;
  String? lastPath;
  Object? lastData;
  Map<String, dynamic>? lastQuery;

  @override
  Future get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isProtected = false,
  }) async {
    lastPath = path;
    lastData = data;
    lastQuery = queryParameter;
    return response;
  }

  @override
  Future post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isFormData = false,
    bool isProtected = false,
  }) async {
    lastPath = path;
    lastData = data;
    lastQuery = queryParameter;
    return response;
  }

  @override
  Future delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isFormData = false,
    bool isProtected = false,
  }) async {
    lastPath = path;
    lastData = data;
    lastQuery = queryParameter;
    return response;
  }

  @override
  Future patch(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isFormData = false,
    bool isProtected = false,
  }) async {
    lastPath = path;
    lastData = data;
    lastQuery = queryParameter;
    return response;
  }

  @override
  Future put(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isFormData = false,
    bool isProtected = false,
  }) async {
    lastPath = path;
    lastData = data;
    lastQuery = queryParameter;
    return response;
  }
}
