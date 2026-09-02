import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:flutter/material.dart';

class CheckIcon extends StatelessWidget {
  const CheckIcon({super.key, required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Icon(
        isSelected ? Icons.check_box : Icons.check_box_outline_blank,
        color: ColorManager.mainColor15,
        size: 22,
      ),
    );
  }
}
