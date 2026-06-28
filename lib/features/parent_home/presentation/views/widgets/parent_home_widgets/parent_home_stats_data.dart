import 'package:bnan_app/core/models/home_state_model.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

List<HomeStateModel> parentHomeStats(BuildContext context) {
  final s = S.of(context);

  return [
    HomeStateModel(
      icon: ImageManager.children,
      value: '2',
      title: s.parentChildren,
      iconColor: ColorManager.blue4260,
    ),
    HomeStateModel(
      icon: ImageManager.certificateBadgeIcon,
      value: '3',
      title: s.parentCertificates,
      iconColor: ColorManager.mainColor14,
    ),
    HomeStateModel(
      icon: ImageManager.starIcon,
      value: '5',
      title: s.parentEvaluations,
    ),
    HomeStateModel(
      icon: ImageManager.subscription,
      value: '2',
      title: s.parentSubscriptions,
      iconColor: ColorManager.redD5,
    ),
  ];
}
