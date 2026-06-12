class PackagesResponseModel {
  final bool success;
  final List<PackageModel> packages;

  const PackagesResponseModel({
    required this.success,
    required this.packages,
  });

  factory PackagesResponseModel.fromJson(Map<String, dynamic> json) {
    return PackagesResponseModel(
      success: json['success'] ?? false,
      packages: (json['data'] as List<dynamic>? ?? [])
          .map((item) => PackageModel.fromJson(item))
          .toList(),
    );
  }
}

class PackageModel {
  final String id;
  final String name;
  final String type;
  final int hours;
  final num oldPrice;
  final num price;
  final bool isPopular;
  final String createdAt;
  final String updatedAt;

  const PackageModel({
    required this.id,
    required this.name,
    required this.type,
    required this.hours,
    required this.oldPrice,
    required this.price,
    required this.isPopular,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    return PackageModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      hours: json['hours'] ?? 0,
      oldPrice: json['oldPrice'] ?? 0,
      price: json['price'] ?? 0,
      isPopular: json['isPopular'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}