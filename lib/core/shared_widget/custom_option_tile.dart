import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/core/shared_widget/selection_circle.dart';
import 'package:flutter/material.dart';

class CustomOptionTile extends StatelessWidget {
  const CustomOptionTile({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: ColorManager.white,
          border: Border.all(color: const Color(0xffCFE2FF)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            SelectionCircle(isSelected: isSelected),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: StylesManager.styleRegular16(context).copyWith(
                  color: ColorManager.mainColor14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
