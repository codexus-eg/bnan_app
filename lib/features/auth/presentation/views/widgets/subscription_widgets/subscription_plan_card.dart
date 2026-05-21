import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/auth/data/models/subscription_plan_model.dart';
import 'package:bnan_app/features/auth/presentation/views/widgets/subscription_widgets/popular_badge.dart';
import 'package:bnan_app/features/auth/presentation/views/widgets/subscription_widgets/subscribe_button.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SubscriptionPlanCard extends StatelessWidget {
  const SubscriptionPlanCard({super.key, required this.plan});

  final SubscriptionPlanModel plan;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsetsDirectional.only(
            start: 8,
            end: 8,
            top: 14,
            bottom: 8,
          ),
          decoration: BoxDecoration(
            color: ColorManager.greyF8F9,
            border: Border.all(
              color: plan.isPopular
                  ? ColorManager.mainColor14
                  : Colors.transparent,
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: ColorManager.black.withAlpha((255 * .25).round()),
                blurRadius: 4,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: 15,
                backgroundColor: ColorManager.greyF4F6,
                child: Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: SvgPicture.asset(ImageManager.clockThreeIcon),
                ),
              ),
              const SizedBox(height: 9),
              Text(plan.title, style: StylesManager.styleBold14(context)),
              const SizedBox(height: 9),
              Container(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: 14,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: ColorManager.greyF4F6,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  plan.hours,
                  style: StylesManager.styleBold8(context),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                plan.oldPrice,
                style: StylesManager.styleRegular12(context).copyWith(
                  decoration: TextDecoration.lineThrough,
                  color: ColorManager.greyA8AF,
                ),
              ),
              const SizedBox(height: 9),
              Text(plan.price, style: StylesManager.styleBold24(context)),
              const SizedBox(height: 9),
              Text(plan.save, style: StylesManager.styleBold8(context)),
              const SizedBox(height: 9),
              SubscribeButton(text: S.of(context).subscribeNow, onTap: () {}),
            ],
          ),
        ),
        if (plan.isPopular) PopularBadge(text: S.of(context).mostPopular),
      ],
    );
  }
}
