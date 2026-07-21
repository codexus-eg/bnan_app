import '../certificates_pagination_model.dart';
import '../monthly_certificate_summary_model.dart';
import '../relation_parser.dart';

class MonthlyCertificatesResponseModel {
  const MonthlyCertificatesResponseModel({
    required this.success,
    required this.length,
    required this.data,
    required this.pagination,
  });

  final bool? success;
  final int? length;
  final List<MonthlyCertificateSummaryModel> data;
  final CertificatesPaginationModel? pagination;

  factory MonthlyCertificatesResponseModel.fromJson(Map<String, dynamic> json) {
    final dataJson = json['data'];
    final paginationMap = RelationParser.mapOf(json['pagination']);

    return MonthlyCertificatesResponseModel(
      success: json['success'] is bool ? json['success'] as bool : null,
      length: int.tryParse(json['length']?.toString() ?? ''),
      data: dataJson is List
          ? dataJson
                .whereType<Map>()
                .map(
                  (item) => MonthlyCertificateSummaryModel.fromJson(
                    Map<String, dynamic>.from(item),
                  ),
                )
                .toList()
          : const [],
      pagination: paginationMap == null
          ? null
          : CertificatesPaginationModel.fromJson(paginationMap),
    );
  }
}
