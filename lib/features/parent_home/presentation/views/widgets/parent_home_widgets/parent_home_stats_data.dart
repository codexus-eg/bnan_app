import 'package:bnan_app/core/models/home_state_model.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/dashboard/data/models/parent_dashboard_model.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

List<HomeStateModel> parentHomeStats(
  BuildContext context,
  ParentDashboardModel data,
) => [
  HomeStateModel(
    icon: ImageManager.children,
    value: '${data.childrenCount}',
    title: S.of(context).parentChildren,
    iconColor: ColorManager.blue4260,
  ),
  HomeStateModel(
    icon: ImageManager.certificateBadgeIcon,
    value: '${data.certificates}',
    title: S.of(context).parentCertificates,
    iconColor: ColorManager.mainColor14,
  ),
  HomeStateModel(
    icon: ImageManager.starIcon,
    value: '${data.evaluations}',
    title: S.of(context).parentEvaluations,
  ),
  HomeStateModel(
    icon: ImageManager.subscription,
    value: '${data.subscriptions}',
    title: S.of(context).parentSubscriptions,
    iconColor: ColorManager.redD5,
  ),
];
