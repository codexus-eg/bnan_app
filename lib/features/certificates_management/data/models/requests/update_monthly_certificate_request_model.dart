import 'certificate_subject_request_model.dart';

class UpdateMonthlyCertificateRequestModel {
  const UpdateMonthlyCertificateRequestModel({
    this.subjects,
    this.signerName,
  });

  final List<CertificateSubjectRequestModel>? subjects;
  final String? signerName;

  Map<String, dynamic> toJson() {
    return {
      if (subjects != null)
        'subjects': subjects!.map((subject) => subject.toJson()).toList(),
      if (signerName != null && signerName!.trim().isNotEmpty)
        'signerName': signerName!.trim(),
    };
  }
}
