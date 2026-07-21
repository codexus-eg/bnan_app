import '../monthly_certificate_model.dart';
import '../relation_parser.dart';

class IssueMonthlyCertificatesResponseModel {
  const IssueMonthlyCertificatesResponseModel({
    required this.success,
    required this.certificates,
  });

  final bool? success;
  final List<MonthlyCertificateModel> certificates;

  factory IssueMonthlyCertificatesResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final dataMap = RelationParser.mapOf(json['data']);
    final certificatesJson = dataMap?['certificates'];

    return IssueMonthlyCertificatesResponseModel(
      success: json['success'] is bool ? json['success'] as bool : null,
      certificates: certificatesJson is List
          ? certificatesJson
                .whereType<Map>()
                .map(
                  (item) => MonthlyCertificateModel.fromJson(
                    Map<String, dynamic>.from(item),
                  ),
                )
                .toList()
          : const [],
    );
  }
}
