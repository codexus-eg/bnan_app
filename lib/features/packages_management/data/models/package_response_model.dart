import 'package:bnan_app/features/packages_management/data/models/package_model.dart';

class PackageResponseModel {
  final bool success;
  final PackageModel? data;

  const PackageResponseModel({
    required this.success,
    this.data,
  });

  factory PackageResponseModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];

    return PackageResponseModel(
      success: json['success'] as bool? ?? false,
      data: rawData is Map
          ? PackageModel.fromJson(
              Map<String, dynamic>.from(rawData),
            )
          : null,
    );
  }
}