import 'package:bnan_app/features/packages_management/data/models/package_access_scope.dart';

class PackageModel {
  final String? id;
  final String? name;
  final String? curriculum;
  final String? type;
  final String accessScope;
  final int? hours;
  final num? purchasedHours;
  final num? remainingHours;
  final int? months;
  final num? oldPrice;
  final num? price;
  final String? currency;
  final String? description;
  final String? discountTitle;
  final bool? isPopular;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PackageModel({
    this.id,
    this.name,
    this.curriculum,
    this.type,
    this.accessScope = PackageAccessScope.allSubjects,
    this.hours,
    this.purchasedHours,
    this.remainingHours,
    this.months,
    this.oldPrice,
    this.price,
    this.currency,
    this.description,
    this.discountTitle,
    this.isPopular,
    this.isActive = false,
    this.createdAt,
    this.updatedAt,
  });

  bool get isSingleSubject => accessScope == PackageAccessScope.singleSubject;
  bool get isSharedSubjects => accessScope == PackageAccessScope.sharedSubjects;
  bool get isAllSubjects => accessScope == PackageAccessScope.allSubjects;

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    return PackageModel(
      id: (json['id'] ?? json['_id'])?.toString(),
      name: json['name']?.toString(),
      curriculum: _curriculumId(json['curriculum']),
      type: _normalized(json['type'] ?? json['packageType']),
      accessScope:
          _normalized(json['accessScope']) ?? PackageAccessScope.allSubjects,
      hours: _toInt(json['hours']),
      purchasedHours: _toNum(json['purchasedHours']),
      remainingHours: _toNum(json['remainingHours']),
      months: _toInt(json['months']),
      oldPrice: _toNum(json['oldPrice']),
      price: _toNum(json['price']),
      currency: json['currency']?.toString(),
      description: json['description']?.toString(),
      discountTitle: json['discountTitle']?.toString(),
      isPopular: json['isPopular'] as bool?,
      isActive: json['isActive'] == true,
      createdAt: _toDateTime(json['createdAt']),
      updatedAt: _toDateTime(json['updatedAt']),
    );
  }

  static int? _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '');
  }

  static num? _toNum(dynamic value) {
    if (value is num) return value;
    return num.tryParse(value?.toString() ?? '');
  }

  static DateTime? _toDateTime(dynamic value) {
    return DateTime.tryParse(value?.toString() ?? '');
  }

  static String? _normalized(dynamic value) {
    final text = value?.toString().trim().toLowerCase() ?? '';
    return text.isEmpty ? null : text;
  }

  static String? _curriculumId(dynamic value) {
    if (value is Map) {
      final id = value['id'] ?? value['_id'];
      return id?.toString();
    }
    return value?.toString();
  }
}
