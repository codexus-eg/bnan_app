import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/shared_profile/data/models/logged_user_model.dart';
import 'package:bnan_app/core/shared_widget/custom_avatar.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ProfileInfoCard extends StatelessWidget {
  final LoggedUserModel loggedUser;

  const ProfileInfoCard({super.key, required this.loggedUser});

  @override
  Widget build(BuildContext context) {
    return CustomDetailsWidgetBackground(
      padding: const EdgeInsetsDirectional.fromSTEB(12, 16, 12, 16),
      child: Row(
        children: [
          CustomAvatar(firstName: loggedUser.user.fullName),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loggedUser.user.fullName,
                  style: StylesManager.styleBold20(
                    context,
                  ).copyWith(color: ColorManager.mainColor14),
                ),
                const SizedBox(height: 6),
                Text(
                  loggedUser.grade?.name ?? S.of(context).studentProfileGrade,
                  style: StylesManager.styleBold16(
                    context,
                  ).copyWith(color: ColorManager.greyA8AF),
                ),
                const SizedBox(height: 6),
                Text(
                  S.of(context).studentProfileClass,
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
