import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/shared_widget/custom_avatar.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class ProfileInfoCard extends StatelessWidget {
  const ProfileInfoCard({
    super.key,
    required this.fullName,
    required this.subtitle,
  });

  final String fullName;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return CustomDetailsWidgetBackground(
      padding: const EdgeInsetsDirectional.fromSTEB(12, 16, 12, 16),
      child: Row(
        children: [
          CustomAvatar(firstName: fullName),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fullName,
                  style: StylesManager.styleBold20(
                    context,
                  ).copyWith(color: ColorManager.mainColor14),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: StylesManager.styleBold16(
                    context,
                  ).copyWith(color: ColorManager.greyA8AF),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
