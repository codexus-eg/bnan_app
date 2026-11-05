import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/features/certificates_management/data/models/teacher_certificate_model.dart';
import 'package:bnan_app/features/certificates_management/data/repo/certificates_management_repo_impl.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/teacher_certificates_cubit/teacher_certificates_cubit.dart';
import 'package:bnan_app/features/ideal_teacher/data/models/supervisor_teacher_model.dart';
import 'package:bnan_app/features/ideal_teacher/data/repos/supervisor_ideal_teacher_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TeacherCertificateModel contract', () {
    test('parses draft general_teacher certificate correctly', () {
      final json = {
        '_id': 'cert_123',
        'certificateType': 'general_teacher',
        'status': 'draft',
        'recipientName': 'أحمد إبراهيم',
        'teacher': {'_id': 'teach_1', 'fullName': 'أحمد إبراهيم'},
        'previewImagePath': '/preview.png',
        'pdfPath': '',
        'createdAt': '2026-10-25T10:00:00Z',
      };
      final model = TeacherCertificateModel.fromJson(json);

      expect(model.id, 'cert_123');
      expect(model.isDraft, isTrue);
      expect(model.hasPdf, isFalse);
      expect(model.recipientName, 'أحمد إبراهيم');
      expect(model.teacherName, 'أحمد إبراهيم');
      expect(model.certificateType, 'general_teacher');
    });

    test('parses issued certificate with issuedAt timestamp', () {
      final json = {
        '_id': 'cert_456',
        'certificateType': 'general_teacher',
        'status': 'issued',
        'recipientName': 'سارة محمد',
        'pdfPath': 'https://example.com/cert.pdf',
        'issuedAt': '2026-10-26T12:00:00Z',
      };
      final model = TeacherCertificateModel.fromJson(json);

      expect(model.id, 'cert_456');
      expect(model.isDraft, isFalse);
      expect(model.hasPdf, isTrue);
      expect(model.status, 'issued');
      expect(model.issuedAt, isNotNull);
    });
  });

  group('CertificatesManagementRepoImpl contracts', () {
    test('createTeacherCertificateDraft posts recipientName and no signerName',
        () async {
      final api = _MockApi(response: {
        'success': true,
        'data': {
          'certificate': {
            '_id': 'cert_new',
            'status': 'draft',
            'recipientSnapshot': {'fullName': 'Custom Teacher'},
            'previewImagePath': '/img.png',
            'pdfPath': null,
          }
        }
      });
      final repo = CertificatesManagementRepoImpl(api);
      final result = await repo.createTeacherCertificateDraft(
        teacherId: 'teacher_10',
        recipientName: 'Custom Teacher',
      );
      expect(api.lastPath, '/supervisors/me/teachers/teacher_10/certificate');
      expect(api.lastData, {'recipientName': 'Custom Teacher'});
      expect((api.lastData as Map).containsKey('signerName'), isFalse);
      result.fold(
        (f) => fail('Expected success: ${f.message}'),
        (cert) {
          expect(cert.id, 'cert_new');
          expect(cert.isDraft, isTrue);
          expect(cert.recipientName, 'Custom Teacher');
        },
      );
    });

    test('issueGeneralTeacherCertificate posts to issue endpoint with no body',
        () async {
      final api = _MockApi(response: {
        'success': true,
        'data': {
          'certificate': {
            '_id': 'cert_123',
            'status': 'issued',
            'pdfPath': '/issued.pdf',
            'issuedAt': '2026-10-27T01:00:00Z',
          }
        }
      });
      final repo = CertificatesManagementRepoImpl(api);
      final result = await repo.issueGeneralTeacherCertificate(
        certificateId: 'cert_123',
      );
      expect(api.lastPath, '/certificates/cert_123/general-teacher/issue');
      expect(api.lastData, isNull);
      result.fold(
        (f) => fail('Expected success: ${f.message}'),
        (cert) {
          expect(cert.status, 'issued');
          expect(cert.isIssued, isTrue);
          expect(cert.hasPdf, isTrue);
        },
      );
    });

    test('getAdminCertificates queries general_teacher and status', () async {
      final api = _MockApi(response: {
        'success': true,
        'data': [],
        'pagination': {'total': 0}
      });
      final repo = CertificatesManagementRepoImpl(api);
      await repo.getAdminCertificates(status: 'draft', page: 1, limit: 20);
      expect(api.lastPath, '/certificates/admin');
      expect(api.lastQuery, {
        'page': 1,
        'limit': 20,
        'certificateType': 'general_teacher',
        'status': 'draft',
      });
    });
  });

  group(
      'TeacherCertificatesCubit role filtering and duplicate issue prevention',
      () {
    test('Teacher role (mine: true) filters out draft certificates', () async {
      final api = _MockApi(response: {
        'success': true,
        'data': [
          {
            '_id': 'cert_draft',
            'certificateType': 'general_teacher',
            'status': 'draft',
            'pdfPath': null,
          },
          {
            '_id': 'cert_issued',
            'certificateType': 'general_teacher',
            'status': 'issued',
            'pdfPath': '/pdf.pdf',
            'issuedAt': '2026-10-26T12:00:00Z',
          },
        ],
      });
      final repo = CertificatesManagementRepoImpl(api);
      final cubit = TeacherCertificatesCubit(
        repo,
        _FakeTeachersRepo(),
        mine: true,
      );
      await cubit.load();
      expect(cubit.state.items.length, 1);
      expect(cubit.state.items.first.id, 'cert_issued');
      await cubit.close();
    });
  });
}

class _MockApi implements ApiConsumer {
  _MockApi({required this.response});
  final Object response;
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
  }) async => response;

  @override
  Future patch(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isFormData = false,
    bool isProtected = false,
  }) async => response;

  @override
  Future put(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isFormData = false,
    bool isProtected = false,
  }) async => response;
}

class _FakeTeachersRepo extends SupervisorIdealTeacherRepo {
  @override
  Future<Either<Failure, List<SupervisorTeacherModel>>> getTeachers() async =>
      const Right([]);

  @override
  Future<Either<Failure, Unit>> issueIdealTeachers({
    required List<String> teacherIds,
    String? signerName,
  }) async =>
      const Right(unit);
}
