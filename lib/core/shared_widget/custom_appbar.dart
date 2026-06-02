import 'package:bnan_app/core/helper/my_navigator.dart';
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
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    return AppBar(
      automaticallyImplyLeading: false,
      leading:iconNeeded ? InkWell(
        onTap: () {
          MyNavigator.pop(context);
        },
        child: Icon(isRtl ? Icons.arrow_back : Icons.arrow_forward),
      ):null,
      title: Text(
        headerText,
        style: StylesManager.styleBold18(
          context,
        ).copyWith(color: ColorManager.mainColor14),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
