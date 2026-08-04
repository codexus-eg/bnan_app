import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class RelationshipInfo extends StatelessWidget {
  const RelationshipInfo({
    super.key,
    required this.parentLabel,
    required this.parentName,
    required this.classesLabel,
    required this.classes,
  });

  final String parentLabel;
  final String parentName;
  final String classesLabel;
  final String classes;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$parentLabel: ',
            style: StylesManager.styleBold10(context).copyWith(
              color: ColorManager.mainColor14,
            ),
          ),
          TextSpan(
            text: '$parentName\n',
            style: StylesManager.styleRegular10(context).copyWith(
              color: ColorManager.greyA8AF,
            ),
          ),
          TextSpan(
            text: '$classesLabel: ',
            style: StylesManager.styleBold10(context).copyWith(
              color: ColorManager.mainColor14,
            ),
          ),
          TextSpan(
            text: classes,
            style: StylesManager.styleRegular10(context).copyWith(
              color: ColorManager.greyA8AF,
            ),
          ),
        ],
      ),
    );
  }
}
