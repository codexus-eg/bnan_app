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
    final rawData = json['data'];
    final List values = rawData is List
        ? rawData
        : (rawData is Map && rawData['certificates'] is List
            ? rawData['certificates'] as List
            : (json['certificates'] is List
                ? json['certificates'] as List
                : const []));
    final pagination = RelationParser.mapOf(json['pagination']) ??
        RelationParser.mapOf(rawData is Map ? rawData['pagination'] : null) ??
        const {};
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
