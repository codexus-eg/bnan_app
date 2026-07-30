import 'package:bnan_app/core/shared_widget/custom_app_drawer/drawer_item_model.dart';
import 'package:bnan_app/core/shared_widget/custom_bottom_nav_bar/bottom_nav_item_model.dart';

class SupervisorNavigationItem {
  const SupervisorNavigationItem({
    required this.title,
    required this.icon,
    this.route,
    this.extra,
  });

  final String title;
  final String icon;
  final String? route;
  final Object? extra;

  bool get isEnabled => route != null;

  DrawerItemModel toDrawerItem() {
    return DrawerItemModel(title: title, icon: icon);
  }

  BottomNavItemModel toBottomItem() {
    return BottomNavItemModel(title: title, icon: icon);
  }
}
