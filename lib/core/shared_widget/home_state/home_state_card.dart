import 'package:bnan_app/core/models/home_state_model.dart';
import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeStatCard extends StatelessWidget {
  const HomeStatCard({
    super.key,
    required this.state,
    this.showIcon = true,
    this.titleTextAlign,
    this.titleOverflow,
  });

  final HomeStateModel state;
  final bool showIcon;
  final TextAlign? titleTextAlign;
  final TextOverflow? titleOverflow;

  @override
  Widget build(BuildContext context) {
    return CustomDetailsWidgetBackground(
      padding: const EdgeInsetsDirectional.symmetric(vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            SvgPicture.asset(
              state.icon,
              width: 22,
              height: 22,
              colorFilter: state.iconColor != null
                  ? ColorFilter.mode(state.iconColor!, BlendMode.srcIn)
                  : null,
            ),
            const SizedBox(height: 6),
          ],
          Flexible(
            child: Text(
              state.value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: StylesManager.styleBold20(
                context,
              ).copyWith(color: ColorManager.mainColor14, height: 1.1),
            ),
          ),
          const SizedBox(height: 4),
          Flexible(
            child: Text(
              state.title,
              textAlign: titleTextAlign ?? TextAlign.center,
              maxLines: 2,
              overflow: titleOverflow ?? TextOverflow.ellipsis,
              style: StylesManager.styleRegular14(
                context,
              ).copyWith(color: ColorManager.greyA8AF, height: 1.1),
            ),
          ),
        ],
      ),
    );
  }
}
