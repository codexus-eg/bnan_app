import 'package:bnan_app/core/shared_widget/custom_bottom_nav_bar/bottom_nav_item_model.dart';
import 'package:bnan_app/core/shared_widget/custom_bottom_nav_bar/custom_bottom_nav_bar.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class AdminBottomNavBar extends StatelessWidget {
  const AdminBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return CustomBottomNavBar(
      items: _items(context),
      currentIndex: currentIndex,
      onTap: onTap,
    );
  }

  List<BottomNavItemModel> _items(BuildContext context) {
    final s = S.of(context);
    return [
      BottomNavItemModel(icon: ImageManager.homeIcon, title: s.home),
      BottomNavItemModel(icon: ImageManager.children, title: s.adminUsers),
      BottomNavItemModel(
        icon: ImageManager.teacherBookTwoIcon,
        title: s.subjects,
      ),
      BottomNavItemModel(icon: ImageManager.subscription, title: s.packages),
    ];
  }
}
