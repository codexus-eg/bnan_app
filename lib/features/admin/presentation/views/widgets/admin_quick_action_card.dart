import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/admin/data/models/admin_quick_action_model.dart';
import 'package:bnan_app/features/admin/presentation/views/widgets/admin_quick_action_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AdminQuickActionCard extends StatelessWidget {
  const AdminQuickActionCard({super.key, required this.action});

  final AdminQuickActionModel action;

  @override
  Widget build(BuildContext context) {
    return CustomDetailsWidgetBackground(
      child: Row(
        children: [
          Text(
            '<',
            style: StylesManager.styleBold14(
              context,
            ).copyWith(color: ColorManager.greyA8AF),
          ),
          const Spacer(),
          AdminQuickActionContent(action: action),
          const SizedBox(width: 8),
          SvgPicture.asset(
            action.icon,
            width: 22,
            height: 22,
            colorFilter: const ColorFilter.mode(
              ColorManager.mainColor14,
              BlendMode.srcIn,
            ),
          ),
        ],
      ),
    );
  }
}
