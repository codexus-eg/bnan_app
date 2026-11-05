import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/features/certificates_management/data/models/requests/certificate_subject_request_model.dart';
import 'package:bnan_app/features/certificates_management/data/models/requests/create_monthly_certificate_request_model.dart';
import 'package:bnan_app/features/certificates_management/data/models/student_subjects_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('create route carries studentId and body has confirmed backend fields', () {
    const request = CreateMonthlyCertificateRequestModel(
      studentId: 'student-profile-id',
      classroomId: 'classroom-1',
      subjects: [
        CertificateSubjectRequestModel(
          subjectId: 'real-subject-id',
          score: 18,
          maxScore: 20,
        ),
      ],
      signerName: 'Teacher Name',
    );

    expect(
      EndPoints.studentMonthlyCertificates,
      '/certificates/student-monthly',
    );
    expect(request.toJson(), {
      'studentId': 'student-profile-id',
      'classroomId': 'classroom-1',
      'signerName': 'Teacher Name',
      'subjects': [
        {'subjectId': 'real-subject-id', 'maxScore': 20, 'score': 18},
      ],
    });
    expect(
      request.toJson().keys,
      unorderedEquals(['studentId', 'classroomId', 'signerName', 'subjects']),
    );
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
