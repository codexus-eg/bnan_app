import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class ParentPlaceholderPage extends StatelessWidget {
  const ParentPlaceholderPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Center(
        child: Text(
          title,
          style: StylesManager.styleBold20(context).copyWith(
            color: ColorManager.mainColor14,
          ),
        ),
      ),
    );
  }
}
