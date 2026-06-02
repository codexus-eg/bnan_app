import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class GroupsSectionTitle extends StatelessWidget {
  const GroupsSectionTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 8),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          title,
          style: StylesManager.styleBold14(context).copyWith(
            color: ColorManager.mainColor14,
          ),
        ),
      ),
    );
  }
}