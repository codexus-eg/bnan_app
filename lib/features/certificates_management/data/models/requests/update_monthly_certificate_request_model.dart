import 'certificate_subject_request_model.dart';

class UpdateMonthlyCertificateRequestModel {
  const UpdateMonthlyCertificateRequestModel({required this.subjects});

  final List<CertificateSubjectRequestModel> subjects;

  Map<String, dynamic> toJson() {
    return {'subjects': subjects.map((subject) => subject.toJson()).toList()};
  }
}
