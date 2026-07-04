import 'package:bnan_app/core/models/home_state_model.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

List<HomeStateModel> adminSubscriptionStats(BuildContext context) {
  final s = S.of(context);
  return [
    HomeStateModel(
      icon: ImageManager.adminShieldCheckIcon,
      value: '-',
      title: s.activeSubscriptions,
      iconColor: ColorManager.orangeE4,
    ),

    HomeStateModel(
      icon: ImageManager.adminDollarSignIcon,
      value: '-',
      title: s.expiredSubscriptions,
      iconColor: ColorManager.redD5,
    ),

    HomeStateModel(
      icon: ImageManager.adminDollarSignIcon,
      value: '-',
      title: s.pendingReceipts,
      iconColor: ColorManager.secondaryColor,
    ),
  ];
}
