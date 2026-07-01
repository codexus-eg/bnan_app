import 'package:bnan_app/core/models/home_state_model.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

List<HomeStateModel> adminStats(BuildContext context) {
  final s = S.of(context);
  return [
    HomeStateModel(
      icon: ImageManager.userProfileGroupIcon,
      value: '29',
      title: s.totalStudents,
      iconColor: ColorManager.mainColor14,
    ),
    HomeStateModel(
      icon: ImageManager.teacherBookTwoIcon,
      value: '1',
      title: s.pendingRegisterRequests,
      iconColor: ColorManager.secondaryColor,
    ),
    HomeStateModel(
      icon: ImageManager.adminDollarSignIcon,
      value: '300',
      title: s.monthlyRevenue,
      iconColor: ColorManager.orangeE4,
    ),
    HomeStateModel(
      icon: ImageManager.adminWindowBulletListAddIcon,
      value: '38',
      title: s.teachers,
      iconColor: ColorManager.secondaryColor,
    ),
    HomeStateModel(
      icon: ImageManager.teacherUserProfileGroupIcon,
      value: '5',
      title: s.activeSubscriptions,
      iconColor: ColorManager.orangeE4,
    ),
    HomeStateModel(
      icon: ImageManager.calendarIcon,
      value: '6',
      title: s.todayClasses,
      iconColor: ColorManager.redD8,
    ),
  ];
}
