class AddPackageRequestModel {
  final String name;
  final String curriculum;
  final String type;
  final String accessScope;
  final int? hours;
  final int? months;
  final num oldPrice;
  final num price;
  final String currency;
  final String? description;
  final String? discountTitle;
  final bool isPopular;

  const AddPackageRequestModel({
    required this.name,
    required this.curriculum,
    required this.type,
    required this.accessScope,
    this.hours,
    this.months,
    required this.oldPrice,
    required this.price,
    required this.currency,
    this.description,
    this.discountTitle,
    this.isPopular = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name.trim(),
      'curriculum': curriculum,
      'type': type,
      'accessScope': accessScope,
      'hours': hours,
      'months': months,
      'oldPrice': oldPrice,
      'price': price,
      'currency': currency,
      if (description?.trim().isNotEmpty == true)
        'description': description!.trim(),
      if (discountTitle?.trim().isNotEmpty == true)
        'discountTitle': discountTitle!.trim(),
      'isPopular': isPopular,
    };
  }
}
