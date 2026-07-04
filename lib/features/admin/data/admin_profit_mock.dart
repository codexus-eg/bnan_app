import 'package:bnan_app/core/models/home_state_model.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

List<HomeStateModel> adminDailyProfitStats(BuildContext context) {
  return _profitStats(S.of(context));
}

List<HomeStateModel> adminMonthlyProfitStats(BuildContext context) {
  return _profitStats(S.of(context));
}

List<HomeStateModel> _profitStats(S s) {
  return [
    HomeStateModel(
      icon: ImageManager.adminDollarSignIcon,
      value: '500',
      title: s.sarShort,
      iconColor: ColorManager.green33B,
    ),
    HomeStateModel(
      icon: ImageManager.adminDollarSignIcon,
      value: '1900',
      title: s.egpShort,
      iconColor: ColorManager.green33B,
    ),
  ];
}
