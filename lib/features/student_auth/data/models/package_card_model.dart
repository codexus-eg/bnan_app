import 'package:bnan_app/features/packages_management/data/models/package_model.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class PackageCardModel {
  final String id;
  final String title;
  final String durationText;
  final String oldPriceText;
  final String priceText;
  final String saveText;
  final bool isPopular;

  const PackageCardModel({
    required this.id,
    required this.title,
    required this.durationText,
    required this.oldPriceText,
    required this.priceText,
    required this.saveText,
    required this.isPopular,
  });

  factory PackageCardModel.fromPackage({
    required BuildContext context,
    required PackageModel package,
  }) {
    final oldPrice = package.oldPrice ?? 0;
    final price = package.price ?? 0;
    final saveValue = oldPrice - price;

    return PackageCardModel(
      id: package.id ?? '',
      title: package.name ?? '',
      durationText: _durationText(context, package),
      oldPriceText: S.of(context).oldPrice(oldPrice.toInt().toString()),
      priceText: S.of(context).currentPrice(price.toInt().toString()),
      saveText: S.of(context).saveAmount(saveValue.toInt().toString()),
      isPopular: package.isPopular ?? false,
    );
  }

  static String _durationText(
    BuildContext context,
    PackageModel package,
  ) {
    if (package.type == 'monthly') {
      return '${package.months ?? 0} شهر';
    }

    return S.of(context).trainingHours(
      (package.hours ?? 0).toString(),
    );
  }

  static List<PackageCardModel> placeholders(BuildContext context) {
    return List.generate(
      4,
      (_) => PackageCardModel(
        id: '',
        title: S.of(context).hoursPackage('8'),
        durationText: S.of(context).trainingHours('8'),
        oldPriceText: S.of(context).oldPrice('380'),
        priceText: S.of(context).currentPrice('300'),
        saveText: S.of(context).saveAmount('80'),
        isPopular: false,
      ),
    );
  }
}