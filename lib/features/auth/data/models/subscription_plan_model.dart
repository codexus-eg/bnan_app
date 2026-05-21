class SubscriptionPlanModel {
  const SubscriptionPlanModel({
    required this.title,
    required this.hours,
    required this.lessons,
    required this.oldPrice,
    required this.price,
    required this.save,
    this.isPopular = false,
  });

  final String title;
  final String hours;
  final String lessons;
  final String oldPrice;
  final String price;
  final String save;
  final bool isPopular;
}