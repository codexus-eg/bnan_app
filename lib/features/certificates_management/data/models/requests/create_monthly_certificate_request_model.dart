import 'certificate_subject_request_model.dart';

class CreateMonthlyCertificateRequestModel {
  const CreateMonthlyCertificateRequestModel({
    required this.classroomId,
    required this.studentId,
    required this.subjects,
  });

  final String classroomId;
  final String studentId;
  final List<CertificateSubjectRequestModel> subjects;

  Map<String, dynamic> toJson() {
    return {
      'classroomId': classroomId,
      'studentId': studentId,
      'subjects': subjects.map((subject) => subject.toJson()).toList(),
    };
  }
}
