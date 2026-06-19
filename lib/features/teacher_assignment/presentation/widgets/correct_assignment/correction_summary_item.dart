import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CorrectionSummaryItem extends StatelessWidget {
  const CorrectionSummaryItem({
    super.key,
    required this.count,
    required this.title,
    required this.image,
  });

  final int count;
  final String title, image;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.only(top: 8,bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(color: ColorManager.greyA8AF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                image,
                height: 16,
                width: 16,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 4),
              Text(
                '$count',
                textAlign: TextAlign.end,
                style: StylesManager.styleBold14(
                  context,
                ).copyWith(color: ColorManager.mainColor14),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(title, style: StylesManager.styleBold10(context)),
        ],
      ),
    );
  }
}
