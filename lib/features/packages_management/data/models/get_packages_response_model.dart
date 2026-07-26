import 'package:bnan_app/features/packages_management/data/models/package_model.dart';

class GetPackagesResponseModel {
  final bool success;
  final int length;
  final List<PackageModel> data;

  const GetPackagesResponseModel({
    required this.success,
    required this.length,
    required this.data,
  });

  factory GetPackagesResponseModel.fromJson(Map<String, dynamic> json) {
    final items = json['data'] as List<dynamic>? ?? [];

    return GetPackagesResponseModel(
      success: json['success'] as bool? ?? false,
      length: json['length'] as int? ?? items.length,
      data: items
          .whereType<Map<String, dynamic>>()
          .map(PackageModel.fromJson)
          .toList(),
    );
  }
}