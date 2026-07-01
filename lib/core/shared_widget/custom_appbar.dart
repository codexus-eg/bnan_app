import 'package:bnan_app/core/shared_widget/custom_back_icon.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar({
    super.key,
    required this.headerText,
    this.iconNeeded = true,
  });

  final String headerText;
  final bool iconNeeded;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      
      leading: iconNeeded ? const CustomBackIcon() : null,
      title: Text(
        headerText,
        style: StylesManager.styleBold18(context).copyWith(
          color: ColorManager.black,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}