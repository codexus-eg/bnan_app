import 'package:bnan_app/features/certificates_management/data/models/certificates_pagination_model.dart';
import 'package:bnan_app/features/certificates_management/data/models/relation_parser.dart';
import 'package:bnan_app/features/certificates_management/data/models/teacher_certificate_model.dart';

class TeacherCertificatesResponseModel {
  const TeacherCertificatesResponseModel({
    required this.data,
    required this.pagination,
  });

  final List<TeacherCertificateModel> data;
  final CertificatesPaginationModel pagination;

  factory TeacherCertificatesResponseModel.fromJson(Map<String, dynamic> json) {
    final values = json['data'] is List ? json['data'] as List : const [];
    final pagination = RelationParser.mapOf(json['pagination']) ?? const {};
    return TeacherCertificatesResponseModel(
      data: values
          .whereType<Map>()
          .map(
            (item) => TeacherCertificateModel.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList(growable: false),
      pagination: CertificatesPaginationModel.fromJson(pagination),
    );
  }
}
