import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomSystemui extends StatelessWidget {
  const CustomSystemui({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: ColorManager.mainColor14,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: child,
    );
  }
}
