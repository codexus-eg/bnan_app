import 'package:bnan_app/core/shared_widget/custom_app_drawer/drawer_item_model.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

List<DrawerItemModel> teacherDrawerItems(BuildContext context) {
  final s = S.of(context);

  return [
    DrawerItemModel(
      title: s.home,
      icon: ImageManager.homeIcon,
    ),
    DrawerItemModel(
      title: s.classes,
      icon: ImageManager.teacherGraduationCapIcon,
    ),
    DrawerItemModel(
      title: s.schedule,
      icon: ImageManager.tableIcon,
    ),
    DrawerItemModel(
      title: s.classesManagement,
      icon: ImageManager.teacherBookTwoIcon,
    ),
    DrawerItemModel(
      title: s.evaluations,
      icon: ImageManager.starIcon,
    ),
    DrawerItemModel(
      title: s.assignments,
      icon: ImageManager.fileIcon,
    ),
    DrawerItemModel(
      title: s.registrationRequests,
      icon: ImageManager.fileQuestionIcon,
    ),
    DrawerItemModel(
      title: s.myGroups,
      icon: ImageManager.teacherUserProfileGroupIcon,
    ),
    DrawerItemModel(
      title: s.dues,
      icon: ImageManager.wallet,
    ),
    DrawerItemModel(
      title: s.certificates,
      icon: ImageManager.certificateBadgeIcon,
    ),
    DrawerItemModel(
      title: s.performance,
      icon: ImageManager.arrowGrowthIcon,
    ),
    DrawerItemModel(
      title: s.weeklyPlans,
      icon: ImageManager.teacherFileEditIcon,
    ),
    DrawerItemModel(
      title: s.quotaReport,
      icon: ImageManager.teacherBarChartIcon,
    ),
    DrawerItemModel(
      title: s.notifications,
      icon: ImageManager.bellIcon,
    ),
    DrawerItemModel(
      title: s.attendance,
      icon: ImageManager.teacherMeetingIcon,
    ),
    DrawerItemModel(
      title: s.myAccount,
      icon: ImageManager.userProfileIcon,
    ),
  ];
}
