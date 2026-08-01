import 'package:bnan_app/core/shared_widget/custom_app_drawer/drawer_item_model.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

List<DrawerItemModel> adminDrawerItems(BuildContext context) {
  final s = S.of(context);
  return [
    DrawerItemModel(title: s.home, icon: ImageManager.homeIcon),
    DrawerItemModel(title: s.usersManagement, icon: ImageManager.children),
    DrawerItemModel(
      title: s.hireTeachers,
      icon: ImageManager.teacherGraduationCapIcon,
    ),
    DrawerItemModel(
      title: s.teacherApplications,
      icon: ImageManager.teacherGraduationCapIcon,
    ),
    DrawerItemModel(
      title: s.registrationRequests,
      icon: ImageManager.tablerSendIcon,
    ),
    DrawerItemModel(
      title: s.classesManagement,
      icon: ImageManager.teacherBookTwoIcon,
    ),
    DrawerItemModel(
      title: s.materialsManagement,
      icon: ImageManager.teacherBookTwoIcon,
    ),
    DrawerItemModel(
      title: s.classRoomManagement,
      icon: ImageManager.teacherBookTwoIcon,
    ),
    DrawerItemModel(title: s.schedule, icon: ImageManager.tableIcon),
    DrawerItemModel(
      title: s.messages,
      icon: ImageManager.parentChatConversationCircleIcon,
    ),
    DrawerItemModel(title: s.notifications, icon: ImageManager.bellIcon),
    DrawerItemModel(title: s.certificates, icon: ImageManager.bellIcon),
    DrawerItemModel(title: s.schedule, icon: ImageManager.bellIcon),
    DrawerItemModel(title: s.assignStudent, icon: ImageManager.bellIcon),
    DrawerItemModel(title: s.curriculum, icon: ImageManager.bellIcon),
    DrawerItemModel(
      title: s.lessonsManagement,
      icon: ImageManager.calendarIcon,
    ),
    DrawerItemModel(title: s.termPlan, icon: ImageManager.tableIcon),
  ];
}
