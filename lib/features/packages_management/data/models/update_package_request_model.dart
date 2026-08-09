class UpdatePackageRequestModel {
  final String? name;
  final String? curriculum;
  final String? type;
  final String? accessScope;
  final int? hours;
  final int? months;
  final num? oldPrice;
  final num? price;
  final String? currency;
  final String? description;
  final String? discountTitle;
  final bool? isPopular;

  const UpdatePackageRequestModel({
    this.name,
    this.curriculum,
    this.type,
    this.accessScope,
    this.hours,
    this.months,
    this.oldPrice,
    this.price,
    this.currency,
    this.description,
    this.discountTitle,
    this.isPopular,
  });

  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name!.trim(),
      if (curriculum != null) 'curriculum': curriculum,
      if (type != null) 'type': type,
      if (accessScope != null) 'accessScope': accessScope,
      if (hours != null) 'hours': hours,
      if (months != null) 'months': months,
      if (oldPrice != null) 'oldPrice': oldPrice,
      if (price != null) 'price': price,
      if (currency != null) 'currency': currency,
      if (description != null) 'description': description!.trim(),
      if (discountTitle != null) 'discountTitle': discountTitle!.trim(),
      if (isPopular != null) 'isPopular': isPopular,
    };
  }
}
