import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class CurriculaHeader extends StatelessWidget {
  const CurriculaHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: S.of(context).studyCurriculaTitle,
                  style: StylesManager.styleBold20(context).copyWith(
                    color: ColorManager.black,
                  ),
                ),
                TextSpan(
                  text: S.of(context).available,
                  style: StylesManager.styleBold20(context).copyWith(
                    color: ColorManager.secondaryColor,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: MediaQuery.of(context).size.width*(237/375),
            child: Text(
              S.of(context).chooseCurriculum,
              textAlign: TextAlign.center,
              style: StylesManager.styleBold14(context).copyWith(
                color: ColorManager.greyA8AF,
              ),
            ),
          ),
        ],
      ),
    );
  }
}