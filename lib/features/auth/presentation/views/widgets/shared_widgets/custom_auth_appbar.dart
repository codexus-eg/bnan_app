import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class CustomAuthAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAuthAppbar({super.key, required this.title, this.onBackTap});

  final String title;
  final VoidCallback? onBackTap;

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: false,
      titleSpacing: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 16),
          Text(title, style: StylesManager.styleMedium16(context)),
          IconButton(
            icon: Icon(
              isRtl ? Icons.arrow_forward : Icons.arrow_back,
              size: 22,
            ),
            onPressed: onBackTap ?? () => MyNavigator.pop(context),
          ),
                    const SizedBox(width: 16),

        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
