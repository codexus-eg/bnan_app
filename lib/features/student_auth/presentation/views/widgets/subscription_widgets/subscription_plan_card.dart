import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/student_auth/data/models/package_card_model.dart';
import 'package:bnan_app/features/student_auth/data/models/register_flow_args_model.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/subscription_widgets/popular_badge.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/subscription_widgets/subscribe_button.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SubscriptionPlanCard extends StatelessWidget {
  const SubscriptionPlanCard({
    super.key,
    required this.plan,
    required this.curriculumId, required this.curriculumName,
  });

  final PackageCardModel plan;
  final String curriculumId;
  final String curriculumName;
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
                  plan.hoursText,
                  style: StylesManager.styleBold8(context),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                plan.oldPriceText,
                style: StylesManager.styleRegular12(context).copyWith(
                  decoration: TextDecoration.lineThrough,
                  color: ColorManager.greyA8AF,
                ),
              ),
              const SizedBox(height: 9),
              Text(plan.priceText, style: StylesManager.styleBold24(context)),
              const SizedBox(height: 9),
              Text(plan.saveText, style: StylesManager.styleBold8(context)),
              const SizedBox(height: 9),
              SubscribeButton(
                text: S.of(context).subscribeNow,
                onTap: () {
                  MyNavigator.goTo(
                    context,
                    Routes.studentRegistration,
                    extra: RegisterFlowArgsModel(
                      curriculumId: curriculumId,
                      curriculumName: curriculumName,
                      packageId: plan.id,
                      packageName: plan.title,
                      packagePrice: plan.priceText,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        if (plan.isPopular) PopularBadge(text: S.of(context).mostPopular),
      ],
    );
  }
}
