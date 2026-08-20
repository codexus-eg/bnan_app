import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/student_auth/data/models/package_card_model.dart';
import 'package:bnan_app/features/student_auth/data/models/register_flow_args_model.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/subscription_widgets/popular_badge.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/subscription_widgets/package_scope_badge.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/subscription_widgets/subscribe_button.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SubscriptionPlanCard extends StatelessWidget {
  const SubscriptionPlanCard({
    super.key,
    required this.plan,
    required this.curriculumId,
    required this.curriculumName,
    this.bottomWidget,
    this.registrationMode,
    this.isSelected = false,
  });

  final PackageCardModel plan;
  final String curriculumId;
  final String curriculumName;
  final Widget? bottomWidget;
  final String? registrationMode;
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    final isCompact = plan.hidePrices;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: isCompact ? null : 280,
          width: double.infinity,
          padding: const EdgeInsetsDirectional.only(
            start: 8,
            end: 8,
            top: 10,
            bottom: 8,
          ),
          decoration: BoxDecoration(
            color: ColorManager.greyF8F9,
            border: Border.all(
              color: plan.isPopular || isSelected
                  ? ColorManager.mainColor14
                  : Colors.transparent,
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: ColorManager.black.withAlpha((255 * .25).round()),
                blurRadius: 1,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: isCompact ? MainAxisSize.min : MainAxisSize.max,
            children: [
              CircleAvatar(
                radius: 13,
                backgroundColor: ColorManager.greyF4F6,
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: SvgPicture.asset(ImageManager.clockThreeIcon),
                ),
              ),
              const SizedBox(height: 6),
              SizedBox(
                height: 32,
                child: Center(
                  child: Text(
                    plan.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: StylesManager.styleBold14(context),
                  ),
                ),
              ),
              if (!isCompact || plan.isSingleSubject) ...[
                const SizedBox(height: 4),
                SizedBox(
                  height: 22,
                  child: plan.isSingleSubject
                      ? const Center(child: PackageScopeBadge())
                      : null,
                ),
              ],
              const SizedBox(height: 4),
              Container(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: 14,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: ColorManager.greyF4F6,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  plan.durationText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: StylesManager.styleBold8(context),
                ),
              ),
              const SizedBox(height: 8),
              if (!isCompact) ...[
                SizedBox(
                  height: 16,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      plan.oldPriceText,
                      style: StylesManager.styleRegular12(context).copyWith(
                        decoration: TextDecoration.lineThrough,
                        color: ColorManager.greyA8AF,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                SizedBox(
                  height: 30,
                  width: double.infinity,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      plan.priceText,
                      style: StylesManager.styleBold24(context),
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                SizedBox(
                  height: 24,
                  child: Center(
                    child: Text(
                      plan.saveText,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: StylesManager.styleBold8(context),
                    ),
                  ),
                ),
                const Spacer(),
              ],
              bottomWidget ??
                  SubscribeButton(
                    text: S.of(context).parentChoosePackage,
                    onTap: () {
                      MyNavigator.goTo(
                        context,
                        Routes.studentRegistration,
                        extra: RegisterFlowArgsModel(
                          curriculumId: curriculumId,
                          curriculumName: curriculumName,
                          packageId: plan.id,
                          packageName: plan.title,
                          packagePrice: plan.price % 1 == 0
                              ? plan.price.toInt().toString()
                              : plan.price.toString(),
                          packageCurrency: plan.currency,
                          registrationMode: registrationMode,
                          accessScope: plan.isSingleSubject
                              ? 'single_subject'
                              : 'all_subjects',
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
