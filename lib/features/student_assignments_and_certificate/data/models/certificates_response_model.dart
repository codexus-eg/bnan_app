import 'package:bnan_app/features/student_assignments_and_certificate/data/certificate_model.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/data/models/certificate_parsing.dart';

class CertificatesResponseModel {
  const CertificatesResponseModel({
    required this.success,
    required this.length,
    required this.data,
  });

  factory CertificatesResponseModel.fromJson(Object? json) {
    final map = certificateMap(json);
    final data = certificateList(
      map['data'],
    ).map(CertificateModel.fromJson).toList(growable: false);
    return CertificatesResponseModel(
      success: map['success'] == true,
      length: certificateInt(map['length']),
      data: data,
    );
  }

  final bool success;
  final int length;
  final List<CertificateModel> data;
}
