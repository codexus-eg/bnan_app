import 'package:bnan_app/core/models/home_state_model.dart';
import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeStatCard extends StatelessWidget {
  const HomeStatCard({super.key, required this.state});

  final HomeStateModel state;

  @override
  Widget build(BuildContext context) {
    return CustomDetailsWidgetBackground(
      padding: const EdgeInsetsDirectional.symmetric(vertical: 8),
      child: Column(
        children: [
          SvgPicture.asset(
            state.icon,
            width: 24,
            height: 24,
            colorFilter: state.iconColor != null
                ? ColorFilter.mode(state.iconColor!, BlendMode.srcIn)
                : null,
          ),
          const SizedBox(height: 8),
          Text(
            state.value,
            style: StylesManager.styleBold20(
              context,
            ).copyWith(color: ColorManager.mainColor14),
          ),
          const SizedBox(height: 8),
          Text(
            state.title,
            style: StylesManager.styleRegular14(
              context,
            ).copyWith(color: ColorManager.greyA8AF),
          ),
        ],
      ),
    );
  }
}
