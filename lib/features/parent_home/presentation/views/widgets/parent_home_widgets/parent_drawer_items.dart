import 'package:bnan_app/core/shared_widget/custom_app_drawer/drawer_item_model.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

List<DrawerItemModel> parentDrawerItems(BuildContext context) {
  final s = S.of(context);

  return [
    DrawerItemModel(title: s.parentHomeTitle, icon: ImageManager.homeIcon),
    DrawerItemModel(title: s.parentYourChildren, icon: ImageManager.children),
    DrawerItemModel(
      title: s.parentEvaluations,
      icon: ImageManager.starOutlinedIcon,
    ),
    DrawerItemModel(
      title: s.parentSchedule,
      icon: ImageManager.parentCalendarIcon,
    ),
    DrawerItemModel(
      title: s.parentCertificates,
      icon: ImageManager.certificateBadgeIcon,
    ),
    DrawerItemModel(title: s.parentNotifications, icon: ImageManager.bellIcon),
    DrawerItemModel(
      title: s.parentPackagesAndSubscription,
      icon: ImageManager.subscription,
    ),
    DrawerItemModel(
      title: s.parentMessages,
      icon: ImageManager.parentChatConversationCircleIcon,
    ),
    DrawerItemModel(title: s.parentDailyPlans, icon: ImageManager.fileIcon),
    DrawerItemModel(title: s.parentAccount, icon: ImageManager.userProfileIcon),
  ];
}
