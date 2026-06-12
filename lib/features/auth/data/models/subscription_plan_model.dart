import 'package:bnan_app/features/auth/data/models/package_model.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class SubscriptionPlanModel {
  final String id;
  final String title;
  final String hours;
  final String lessons;
  final String oldPrice;
  final String price;
  final String save;
  final bool isPopular;

  const SubscriptionPlanModel({
    required this.id,
    required this.title,
    required this.hours,
    required this.lessons,
    required this.oldPrice,
    required this.price,
    required this.save,
    this.isPopular = false,
  });

  factory SubscriptionPlanModel.fromPackage({
    required BuildContext context,
    required PackageModel package,
  }) {
    final saveAmount = package.oldPrice - package.price;

    return SubscriptionPlanModel(
      id: package.id,
      title: S.of(context).hoursPackage(package.hours.toString()),
      hours: S.of(context).trainingHours(package.hours.toString()),
      lessons: S.of(context).weeklyLessons(package.hours.toString()),
      oldPrice: S.of(context).oldPrice(package.oldPrice.toInt().toString()),
      price: S.of(context).currentPrice(package.price.toInt().toString()),
      save: S.of(context).saveAmount(saveAmount.toInt().toString()),
      isPopular: package.isPopular,
    );
  }

  static List<SubscriptionPlanModel> placeholders(BuildContext context) {
    return List.generate(
      4,
      (index) => SubscriptionPlanModel(
        id: '',
        title: S.of(context).hoursPackage('8'),
        hours: S.of(context).trainingHours('8'),
        lessons: S.of(context).weeklyLessons('4'),
        oldPrice: S.of(context).oldPrice('380'),
        price: S.of(context).currentPrice('300'),
        save: S.of(context).saveAmount('80'),
      ),
    );
  }
}