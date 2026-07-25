import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class PackageFormValidationMessage {
  const PackageFormValidationMessage._();

  static String fromKey(
    BuildContext context,
    String key,
  ) {
    switch (key) {
      case 'curriculum':
        return S.of(context).selectCurriculumFirst;
      case 'name':
        return S.of(context).packageNameRequired;
      case 'duration':
        return S.of(context).packageDurationInvalid;
      case 'oldPrice':
        return S.of(context).oldPriceInvalid;
      case 'newPrice':
        return S.of(context).newPriceInvalid;
      case 'priceGreaterThanOldPrice':
        return S.of(context).newPriceMustBeLessThanOldPrice;
      case 'currency':
        return S.of(context).currencyRequired;
        case 'packageId':
  return S.of(context).invalidPackage;
      default:
        return S.of(context).invalidData;
    }
  }
}