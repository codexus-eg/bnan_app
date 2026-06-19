import 'package:bnan_app/features/student_auth/data/models/package_model.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class PackageCardModel {
  final String id;
  final String title;
  final String hoursText;
  final String oldPriceText;
  final String priceText;
  final String saveText;
  final bool isPopular;

  const PackageCardModel({
    required this.id,
    required this.title,
    required this.hoursText,
    required this.oldPriceText,
    required this.priceText,
    required this.saveText,
    required this.isPopular,
  });

  factory PackageCardModel.fromPackage({
    required BuildContext context,
    required PackageModel package,
  }) {
    final saveValue = package.oldPrice - package.price;

    return PackageCardModel(
      id: package.id,
      title: S.of(context).hoursPackage(package.hours.toString()),
      hoursText: S.of(context).trainingHours(package.hours.toString()),
      oldPriceText: S.of(context).oldPrice(
        package.oldPrice.toInt().toString(),
      ),
      priceText: S.of(context).currentPrice(
        package.price.toInt().toString(),
      ),
      saveText: S.of(context).saveAmount(
        saveValue.toInt().toString(),
      ),
      isPopular: package.isPopular,
    );
  }

  static List<PackageCardModel> placeholders(BuildContext context) {
    return List.generate(
      4,
      (_) => PackageCardModel(
        id: '',
        title: S.of(context).hoursPackage('8'),
        hoursText: S.of(context).trainingHours('8'),
        oldPriceText: S.of(context).oldPrice('380'),
        priceText: S.of(context).currentPrice('300'),
        saveText: S.of(context).saveAmount('80'),
        isPopular: false,
      ),
    );
  }
}