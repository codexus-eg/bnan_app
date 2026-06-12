import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/home_student/data/models/student_subscription_model.dart';
import 'package:bnan_app/features/home_student/presentation/views/widgets/shared_widgets/progress_line.dart';
import 'package:bnan_app/features/home_student/presentation/views/widgets/student_home_page/package_details/card_header.dart';
import 'package:bnan_app/features/home_student/presentation/views/widgets/student_home_page/package_details/progress_info.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class PackageDetailsCardContent extends StatelessWidget {
  const PackageDetailsCardContent({
    super.key,
    required this.subscription,
  });

  final StudentSubscriptionModel subscription;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsetsDirectional.all(8),
      margin: const EdgeInsetsDirectional.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.2, 1.0],
          colors: [
            ColorManager.mainColor14.withAlpha((255 * .8).round()),
            ColorManager.mainColor14,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardHeader(isActive: subscription.hasActiveSubscription),
          const SizedBox(height: 8),
          ProgressInfo(
            remainingHours: subscription.remainingHours,
            usedHours: subscription.usedHours,
            totalHours: subscription.purchasedHours,
            isDaysPackage: subscription.isDaysPackage,
          ),
          const SizedBox(height: 4),
          ProgressLine(value: subscription.progress),
          const SizedBox(height: 8),
          Text(
            S.of(context).packageExpiryText,
            style: StylesManager.styleRegular12(context).copyWith(
              color: ColorManager.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            S.of(context).upgradePackage,
            style: StylesManager.styleBold14(context).copyWith(
              color: ColorManager.white,
              decoration: TextDecoration.underline,
              decorationColor: ColorManager.white,
            ),
          ),
        ],
      ),
    );
  }
}