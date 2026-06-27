import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:flutter/material.dart';

class CustomSecondBackground extends StatelessWidget {
  const CustomSecondBackground({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            blurRadius: 1,
            offset: const Offset(0, 1),
            color: ColorManager.black.withAlpha((255*.25).round())
          )
        ]
      ),
      child:child ,
      );
  }
}