import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SchedulePickerField extends StatelessWidget {
  const SchedulePickerField({
    super.key,
    required this.label,
    required this.hintText,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final String hintText;
  final String? value;
  final String icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: StylesManager.styleBold14(context).copyWith(
            color: ColorManager.mainColor15,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              border: Border.all(color: ColorManager.borderColor),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                SvgPicture.asset(icon, colorFilter: ColorFilter.mode(ColorManager.greyA8AF, BlendMode.srcIn)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    value ?? hintText,
                    style: StylesManager.styleLight12(context).copyWith(
                      color: value == null
                          ? ColorManager.greyA8AF
                          : ColorManager.mainColor15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}