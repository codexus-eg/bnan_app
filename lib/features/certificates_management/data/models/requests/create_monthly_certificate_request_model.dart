import 'certificate_subject_request_model.dart';

class CreateMonthlyCertificateRequestModel {
  const CreateMonthlyCertificateRequestModel({
    required this.studentId,
    required this.subjects,
  });

  final String studentId;
  final List<CertificateSubjectRequestModel> subjects;

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'subjects': subjects.map((subject) => subject.toJson()).toList(),
    };
  }
}
