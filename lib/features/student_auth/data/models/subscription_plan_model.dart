import 'package:bnan_app/features/packages_management/data/models/package_model.dart';
import 'package:bnan_app/features/packages_management/data/models/package_type.dart';
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
    final oldPrice = package.oldPrice ?? 0;
    final price = package.price ?? 0;
    final saveAmount = oldPrice - price;
    final hoursCount = package.hours ?? 0;
    final monthsCount = package.months ?? 0;

    final isHours = package.type == PackageType.hours;

    return SubscriptionPlanModel(
      id: package.id ?? '',
      title: package.name ?? '',
      hours: isHours
          ? S.of(context).trainingHours(hoursCount.toString())
          : '$monthsCount شهر',
      lessons: isHours
          ? S.of(context).weeklyLessons(hoursCount.toString())
          : '$monthsCount شهر',
      oldPrice: S.of(context).oldPrice(oldPrice.toInt().toString()),
      price: S.of(context).currentPrice(price.toInt().toString()),
      save: S.of(context).saveAmount(saveAmount.toInt().toString()),
      isPopular: package.isPopular ?? false,
    );
  }

  static List<SubscriptionPlanModel> placeholders(BuildContext context) {
    return List.generate(
      4,
      (_) => SubscriptionPlanModel(
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