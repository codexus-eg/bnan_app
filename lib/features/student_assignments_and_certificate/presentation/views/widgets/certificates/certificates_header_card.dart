import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CertificatesHeaderCard extends StatelessWidget {
  const CertificatesHeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsetsDirectional.all(8),
      decoration: BoxDecoration(
       gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.2, 1.0],
          colors: [
            ColorManager.mainColor14.withAlpha((255 * .8).round()),
            ColorManager.mainColor14,
          ],
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            ImageManager.trophyIcon,
            width: 36,
            height: 36,
             colorFilter: const ColorFilter.mode(
              ColorManager.orangeE6,
              BlendMode.srcIn,
            ),
           
          ),
          const SizedBox(height: 8),
          Text(
            S.of(context).congratsThisMonth,
            style: StylesManager.styleRegular12(context).copyWith(
              color: ColorManager.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            S.of(context).newCertificate,
            style: StylesManager.styleBold16(context).copyWith(
              color: ColorManager.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            S.of(context).academicPerformanceMessage,
            style: StylesManager.styleRegular14(context).copyWith(
              color: ColorManager.white,
            ),
          ),
        ],
      ),
    );
  }
}