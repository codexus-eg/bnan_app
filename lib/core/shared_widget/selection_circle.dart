
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:flutter/material.dart';

class SelectionCircle extends StatelessWidget {
  const SelectionCircle({super.key, required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: ColorManager.mainColor15,
          width:isSelected ?5.5 : 2,
        ),
      ),
      
    );
  }
}