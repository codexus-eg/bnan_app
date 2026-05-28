import 'package:bnan_app/core/shared_widget/custom_app_drawer/custom_app_drawer_header.dart';
import 'package:bnan_app/core/shared_widget/custom_app_drawer/custom_app_drawer_item.dart';
import 'package:bnan_app/core/shared_widget/custom_app_drawer/drawer_item_model.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class CustomAppDrawer extends StatelessWidget {
  const CustomAppDrawer({
    super.key,
    required this.userName,
    required this.userSubtitle,
    required this.items,
    required this.selectedIndex,
    required this.onItemTap,
    required this.onLogoutTap,
  });

  final String userName;
  final String userSubtitle;
  final List<DrawerItemModel> items;
  final int selectedIndex;
  final ValueChanged<int> onItemTap;
  final VoidCallback onLogoutTap;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width*(300/375),
      backgroundColor: ColorManager.mainColor14,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.only(
          topStart: Radius.circular(10),
          bottomStart: Radius.circular(10),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(12, 16, 12, 16),
          child: Column(
            children: [
              CustomAppDrawerHeader(
                userName: userName,
                userSubtitle: userSubtitle,
              ),
              Divider(height: 16,color: ColorManager.greyA8AF),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    return CustomAppDrawerItem(
                      title: items[index].title,
                      icon: items[index].icon,
                      isSelected: selectedIndex == index,
                      onTap: () => onItemTap(index),
                    );
                  },
                ),
              ),
              const Divider(color: ColorManager.greyA8AF),
              CustomAppDrawerItem(
                title: S.of(context).logout,
                icon: ImageManager.logout,
                isSelected: false,
                iconColor: ColorManager.black,
                onTap: onLogoutTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}