import 'package:bnan_app/features/packages_management/data/models/package_model.dart';
import 'package:bnan_app/features/packages_management/data/models/package_access_scope.dart';
import 'package:bnan_app/core/helper/currency_formatter.dart';
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
  final num price;
  final String currency;
  final bool isSingleSubject;

  const PackageCardModel({
    required this.id,
    required this.title,
    required this.durationText,
    required this.oldPriceText,
    required this.priceText,
    required this.saveText,
    required this.isPopular,
    required this.price,
    required this.currency,
    required this.isSingleSubject,
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
      oldPriceText: package.oldPrice == null
          ? ''
          : CurrencyFormatter.amount(context, oldPrice, package.currency),
      priceText: CurrencyFormatter.amount(context, price, package.currency),
      saveText: saveValue <= 0
          ? ''
          : '${S.of(context).save} '
                '${CurrencyFormatter.amount(context, saveValue, package.currency)}',
      isPopular: package.isPopular ?? false,
      price: price,
      currency: package.currency ?? '',
      isSingleSubject: package.accessScope == PackageAccessScope.singleSubject,
    );
  }

  static String _durationText(BuildContext context, PackageModel package) {
    if (package.type == 'monthly') {
      return '${package.months ?? 0} شهر';
    }

    return S.of(context).trainingHours((package.hours ?? 0).toString());
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
        price: 0,
        currency: '',
        isSingleSubject: false,
      ),
    );
  }
}
