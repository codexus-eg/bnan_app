import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class SubscriptionHeader extends StatelessWidget {
  const SubscriptionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: S.of(context).Packages,
                style: StylesManager.styleBold20(context).copyWith(
                  color: ColorManager.mainColor14,
                ),
              ),
              TextSpan(
                text: ' ${S.of(context).subscription}',
                style: StylesManager.styleBold20(context).copyWith(
                  color: ColorManager.secondaryColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          S.of(context).canChangeCurrency,
          style: StylesManager.styleBold14(context).copyWith(
            color: ColorManager.greyA8AF,
          ),
        ),
      ],
    );
  }
}