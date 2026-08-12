import 'package:bnan_app/core/shared_widget/custom_app_drawer/drawer_item_model.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

List<DrawerItemModel> studentDrawerItems(BuildContext context) {
  return [
    DrawerItemModel(
      title: S.of(context).dashboard,
      icon: ImageManager.homeIcon,
    ),
    DrawerItemModel(
      title: S.of(context).studyMaterials,
      icon: ImageManager.fileCheckIcon,
    ),
    DrawerItemModel(
      title: S.of(context).requestNewLesson,
      icon: ImageManager.fileQuestionIcon,
    ),
    DrawerItemModel(
      title: S.of(context).myGroups,
      icon: ImageManager.userProfileGroupIcon,
    ),
    DrawerItemModel(
      title: S.of(context).certificates,
      icon: ImageManager.certificateBadgeIcon,
    ),
    DrawerItemModel(
      title: S.of(context).schedule,
      icon: ImageManager.tableIcon,
    ),
    DrawerItemModel(
      title: S.of(context).plansTitle,
      icon: ImageManager.calendarIcon,
    ),
    DrawerItemModel(
      title: S.of(context).PackagesandSubscriptions,
      icon: ImageManager.subscription,
    ),
    DrawerItemModel(
      title: S.of(context).notifications,
      icon: ImageManager.bellIcon,
    ),
    DrawerItemModel(title: S.of(context).reviews, icon: ImageManager.starIcon),
    DrawerItemModel(
      title: S.of(context).assignments,
      icon: ImageManager.fileIcon,
    ),
    DrawerItemModel(
      title: S.of(context).myAccount,
      icon: ImageManager.userProfileIcon,
    ),
    DrawerItemModel(title: S.of(context).messages, icon: ImageManager.chatIcon),
  ];
}
