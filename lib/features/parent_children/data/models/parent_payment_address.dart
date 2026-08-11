class ParentPaymentAddress {
  const ParentPaymentAddress({
    required this.city,
    required this.region,
    required this.line1,
    this.line2 = '',
  });

  final String city;
  final String region;
  final String line1;
  final String line2;

  Map<String, dynamic> toJson() => {
    'city': city.trim(),
    'region': region.trim(),
    'line1': line1.trim(),
    'line2': line2.trim(),
  };
}
