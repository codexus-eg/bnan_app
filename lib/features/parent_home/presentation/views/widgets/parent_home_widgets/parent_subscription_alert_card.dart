import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/shared_widget/status_badge.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ParentSubscriptionAlertCard extends StatelessWidget {
  const ParentSubscriptionAlertCard({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return CustomDetailsWidgetBackground(
      child: Row(
        children: [
          SvgPicture.asset(
            ImageManager.parentCircleWarningIcon,
            width: 24,
            height: 24,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  s.parentSubscriptionEndsSoon,
                  style: StylesManager.styleBold12(
                    context,
                  ).copyWith(color: ColorManager.mainColor14),
                ),
                const SizedBox(height: 8),
                Text(
                  s.parentSubscriptionRenewHint,
                  style: StylesManager.styleRegular12(context),
                ),
              ],
            ),
          ),
          StatusBadge(horizontalPadding: 15, text: s.parentRenew),
        ],
      ),
    );
  }
}
