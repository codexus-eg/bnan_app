import 'certificate_subject_request_model.dart';

class CreateMonthlyCertificateRequestModel {
  const CreateMonthlyCertificateRequestModel({
    required this.studentId,
    this.classroomId,
    required this.subjects,
    required this.signerName,
  });

  final String studentId;
  final String? classroomId;
  final List<CertificateSubjectRequestModel> subjects;
  final String signerName;

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      if (classroomId != null && classroomId!.trim().isNotEmpty)
        'classroomId': classroomId!.trim(),
      'signerName': signerName.trim(),
      'subjects': subjects.map((subject) => subject.toJson()).toList(),
    };
  }
}
