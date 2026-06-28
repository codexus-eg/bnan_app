import 'package:bnan_app/core/shared_widget/custom_app_drawer/drawer_item_model.dart';
import 'package:bnan_app/core/utils/assets.dart';

const List<DrawerItemModel> parentDrawerItems = [
  DrawerItemModel(
    title: 'الرئيسية',
    icon: ImageManager.homeIcon,
  ),
  DrawerItemModel(
    title: 'أبناؤك',
    icon: ImageManager.children,
  ),
  DrawerItemModel(
    title: 'التقييمات',
    icon: ImageManager.starOutlinedIcon,
  ),
  DrawerItemModel(
    title: 'الجدول',
    icon: ImageManager.parentCalendarIcon,
  ),
  DrawerItemModel(
    title: 'الشهادات',
    icon: ImageManager.certificateBadgeIcon,
  ),
  DrawerItemModel(
    title: 'الإشعارات',
    icon: ImageManager.bellIcon,
  ),
  DrawerItemModel(
    title: 'الباقات والاشتراك',
    icon: ImageManager.subscription,
  ),
  DrawerItemModel(
    title: 'الرسائل',
    icon: ImageManager.parentChatConversationCircleIcon,
  ),
  DrawerItemModel(
    title: 'الخطط اليومية',
    icon: ImageManager.fileIcon,
  ),
  DrawerItemModel(
    title: 'حسابي',
    icon: ImageManager.userProfileIcon,
  ),
];
