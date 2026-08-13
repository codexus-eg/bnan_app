import 'package:bnan_app/features/packages_management/data/models/package_model.dart';
import 'package:bnan_app/features/student_auth/data/models/package_card_model.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

abstract class AdminPackageCardMapper {
  static PackageCardModel fromPackage(
    BuildContext context,
    PackageModel package,
  ) {
    final base = PackageCardModel.fromPackage(
      context: context,
      package: package,
    );
    final oldPrice = package.oldPrice ?? 0;
    final price = package.price ?? 0;
    final currency = package.currency?.trim().toUpperCase() ?? '';
    return PackageCardModel(
      id: base.id,
      title: base.title,
      durationText: base.durationText,
      oldPriceText: _money(context, oldPrice, currency),
      priceText: _money(context, price, currency),
      saveText:
          '${S.of(context).discountAmount}: '
          '${_money(context, oldPrice - price, currency)}',
      isPopular: base.isPopular,
      price: base.price,
      currency: currency,
      isSingleSubject: base.isSingleSubject,
    );
  }

  static String _money(BuildContext context, num value, String currency) {
    if (currency.isEmpty) return NumberFormat.decimalPattern().format(value);
    return NumberFormat.simpleCurrency(
      locale: Localizations.localeOf(context).toLanguageTag(),
      name: currency,
      decimalDigits: value % 1 == 0 ? 0 : 2,
    ).format(value);
  }
}
