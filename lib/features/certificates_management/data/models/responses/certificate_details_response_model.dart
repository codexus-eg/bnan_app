import '../monthly_certificate_model.dart';
import '../relation_parser.dart';

class CertificateDetailsResponseModel {
  const CertificateDetailsResponseModel({
    required this.success,
    required this.data,
  });

  final bool? success;
  final MonthlyCertificateModel? data;

  factory CertificateDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    final dataMap = RelationParser.mapOf(json['data']);

    return CertificateDetailsResponseModel(
      success: json['success'] is bool ? json['success'] as bool : null,
      data: dataMap == null ? null : MonthlyCertificateModel.fromJson(dataMap),
    );
  }
}
