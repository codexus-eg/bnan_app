import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class AppTableCell extends StatelessWidget {
  const AppTableCell({
    super.key,
    required this.text,
    required this.isHeader,
    this.width = 64,
  });

  final String text;
  final bool isHeader;
  final double width;

  @override
  Widget build(BuildContext context) {
    final isFirstHeader = isHeader && text == S.of(context).month;
    return Container(
      width: width,
      height: 31,
      margin: const EdgeInsetsDirectional.only(end: 20, bottom: 4),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: isFirstHeader
            ? ColorManager.greyA8AF
            : isHeader
            ? ColorManager.mainColor14
            : ColorManager.white,
      ),
      child: Text(
        text,
        style: StylesManager.styleBold12(context).copyWith(
          color: isHeader ? ColorManager.white : ColorManager.mainColor14,
        ),
      ),
    );
  }
}
