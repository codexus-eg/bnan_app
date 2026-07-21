import '../monthly_certificate_model.dart';
import '../relation_parser.dart';

class CreateMonthlyCertificateResponseModel {
  const CreateMonthlyCertificateResponseModel({
    required this.success,
    required this.certificate,
  });

  final bool? success;
  final MonthlyCertificateModel? certificate;

  factory CreateMonthlyCertificateResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final dataMap = RelationParser.mapOf(json['data']);
    final certificateMap = RelationParser.mapOf(dataMap?['certificate']);

    return CreateMonthlyCertificateResponseModel(
      success: json['success'] is bool ? json['success'] as bool : null,
      certificate: certificateMap == null
          ? null
          : MonthlyCertificateModel.fromJson(certificateMap),
    );
  }
}
