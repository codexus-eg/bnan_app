import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/features/certificates_management/data/models/requests/certificate_subject_request_model.dart';
import 'package:bnan_app/features/certificates_management/data/models/requests/create_monthly_certificate_request_model.dart';
import 'package:bnan_app/features/certificates_management/data/models/student_subjects_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('create route carries studentId and body has only strict fields', () {
    const request = CreateMonthlyCertificateRequestModel(
      studentId: 'student-id',
      subjects: [
        CertificateSubjectRequestModel(
          subjectId: 'real-subject-id',
          score: 15,
          maxScore: 20,
        ),
      ],
      signerName: 'Supervisor Name',
    );

    expect(
      EndPoints.createMonthlyStudentCertificate(request.studentId),
      '/certificates/monthly/student/student-id',
    );
    expect(request.toJson(), {
      'subjects': [
        {'subjectId': 'real-subject-id', 'maxScore': 20, 'score': 15},
      ],
      'signerName': 'Supervisor Name',
    });
    expect(request.toJson().keys, unorderedEquals(['subjects', 'signerName']));
    expect(request.subjects.single.score, isA<num>());
    expect(request.subjects.single.maxScore, isA<num>());
  });

  test('subject ID parser accepts backend ID keys without name fallback', () {
    for (final entry in const {
      'id': 'a',
      'subjectId': 'b',
      '_id': 'c',
    }.entries) {
      expect(
        StudentSubjectModel.fromJson({entry.key: entry.value}).id,
        entry.value,
      );
    }
    expect(StudentSubjectModel.fromJson(const {'name': 'Arabic'}).id, isNull);
  });
}
