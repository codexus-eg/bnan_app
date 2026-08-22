import 'certificate_subject_request_model.dart';

class CreateMonthlyCertificateRequestModel {
  const CreateMonthlyCertificateRequestModel({
    required this.studentId,
    required this.subjects,
    required this.signerName,
  });

  final String studentId;
  final List<CertificateSubjectRequestModel> subjects;
  final String signerName;

  Map<String, dynamic> toJson() {
    return {
      'subjects': subjects.map((subject) => subject.toJson()).toList(),
      'signerName': signerName,
    };
  }
}
