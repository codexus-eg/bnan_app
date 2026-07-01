import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/admin/data/models/admin_quick_action_model.dart';
import 'package:flutter/material.dart';

class AdminQuickActionContent extends StatelessWidget {
  const AdminQuickActionContent({super.key, required this.action});

  final AdminQuickActionModel action;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            action.title,
            overflow: TextOverflow.ellipsis,
            style: StylesManager.styleBold12(
              context,
            ).copyWith(color: ColorManager.mainColor14),
          ),
          Text(
            action.subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: StylesManager.styleRegular10(
              context,
            ).copyWith(color: ColorManager.greyA8AF),
          ),
        ],
      ),
    );
  }
}
