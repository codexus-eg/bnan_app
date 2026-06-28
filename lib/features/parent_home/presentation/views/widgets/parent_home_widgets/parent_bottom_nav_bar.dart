import 'package:bnan_app/core/shared_widget/custom_bottom_nav_bar/bottom_nav_item_model.dart';
import 'package:bnan_app/core/shared_widget/custom_bottom_nav_bar/custom_bottom_nav_bar.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:flutter/material.dart';

class ParentBottomNavBar extends StatelessWidget {
  const ParentBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return CustomBottomNavBar(
      items: _items,
      currentIndex: currentIndex,
      onTap: onTap,
    );
  }

  List<BottomNavItemModel> get _items {
    return const [
      BottomNavItemModel(
        icon: ImageManager.homeIcon,
        title: 'الرئيسية',
      ),
      BottomNavItemModel(
        icon: ImageManager.children,
        title: 'الأبناء',
      ),
      BottomNavItemModel(
        icon: ImageManager.parentChatConversationCircleIcon,
        title: 'الرسائل',
      ),
      BottomNavItemModel(
        icon: ImageManager.subscription,
        title: 'الاشتراك',
      ),
      BottomNavItemModel(
        icon: ImageManager.userProfileIcon,
        title: 'حسابي',
      ),
    ];
  }
}
