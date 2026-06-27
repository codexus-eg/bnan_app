import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SalaryDetailsRow extends StatelessWidget {
  const SalaryDetailsRow({
    super.key,
    required this.title,
    required this.value,
    this.titleColor = ColorManager.greyA8AF,
    this.valueColor = ColorManager.greyA8AF,
    this.icon,
  });

  final String title;
  final String value;
  final Color titleColor;
  final Color valueColor;
  final String? icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        if (icon != null) ...[
          SvgPicture.asset(
            icon!,
            height: 16,
            width: 16,
            colorFilter: ColorFilter.mode(valueColor, BlendMode.srcIn),
          ),
          const SizedBox(width: 4),
        ],
        Text(
          title,
          style: StylesManager.styleRegular14(
            context,
          ).copyWith(color: titleColor),
        ),
        const Spacer(),
        Text(
          value,
          style: StylesManager.styleRegular14(
            context,
          ).copyWith(color: valueColor),
        ),
      ],
    );
  }
}
