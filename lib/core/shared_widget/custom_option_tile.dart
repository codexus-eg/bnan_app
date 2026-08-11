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
    this.isEnabled = true,
    this.subtitle,
  });

  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isEnabled;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isEnabled ? 1 : .55,
      child: GestureDetector(
        onTap: isEnabled ? onTap : null,
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: StylesManager.styleRegular16(
                        context,
                      ).copyWith(color: ColorManager.mainColor14),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: StylesManager.styleLight12(context),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
