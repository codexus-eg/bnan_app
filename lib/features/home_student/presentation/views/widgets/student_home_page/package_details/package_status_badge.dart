import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class PackageStatusBadge extends StatelessWidget {
  const PackageStatusBadge({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsetsDirectional.symmetric(horizontal: 16,vertical: 4),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Text(
        text,
        style: StylesManager.styleBold12(context).copyWith(
          color: ColorManager.mainColor14,
        ),
      ),
    );
  }
}