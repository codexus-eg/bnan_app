import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProfileInfoRow extends StatelessWidget {
  const ProfileInfoRow({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.onEdit,
  });

  final String label;
  final String value;
  final String icon;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 8),
      child: Row(
        children: [
          SvgPicture.asset(icon),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: StylesManager.styleRegular12(context)),
              const SizedBox(height: 4),
              Text(
                value,
                style: StylesManager.styleRegular14(
                  context,
                ).copyWith(color: ColorManager.mainColor14),
              ),
            ],
          ),
          const Spacer(),
          if (onEdit != null)
            IconButton(
              onPressed: onEdit,
              icon: SvgPicture.asset(ImageManager.edit),
              color: ColorManager.greyA8AF,
            )
          else
            const SizedBox(width: 48),
        ],
      ),
    );
  }
}
