import 'package:bnan_app/features/packages_management/data/models/package_model.dart';
import 'package:bnan_app/features/student_auth/data/models/package_card_model.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

abstract class AdminPackageCardMapper {
  static PackageCardModel fromPackage(
    BuildContext context,
    PackageModel package, {
    bool hidePrices = false,
  }) {
    final base = PackageCardModel.fromPackage(
      context: context,
      package: package,
      hidePrices: hidePrices,
    );
    final oldPrice = package.oldPrice ?? 0;
    final price = package.price ?? 0;
    final currency = package.currency?.trim() ?? '';
    return PackageCardModel(
      id: base.id,
      title: base.title,
      durationText: base.durationText,
      oldPriceText: hidePrices ? '' : _money(context, oldPrice, currency),
      priceText: hidePrices ? '' : _money(context, price, currency),
      saveText: hidePrices
          ? ''
          : '${S.of(context).discountAmount}: '
                '${_money(context, oldPrice - price, currency)}',
      isPopular: base.isPopular,
      price: base.price,
      currency: currency,
      isSingleSubject: base.isSingleSubject,
      hidePrices: base.hidePrices,
    );
  }

  static String _money(BuildContext context, num value, String currency) {
    final formatter = NumberFormat.decimalPattern(
      Localizations.localeOf(context).toLanguageTag(),
    )..maximumFractionDigits = value % 1 == 0 ? 0 : 2;
    final amount = formatter.format(value);
    return currency.isEmpty ? amount : '$amount $currency';
  }
}
