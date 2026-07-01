import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DetailRow extends StatelessWidget {
  const DetailRow({
    super.key,
    required this.label,
    this.value,
    required this.icon,
    this.showCopy = false,
  });

  final String label;
  final String? value;
  final String icon;
  final bool? showCopy;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 10),
      child: Row(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(icon),
              const SizedBox(width: 4),
              Text(
                label,
                style: StylesManager.styleMedium10(
                  context,
                ).copyWith(color: ColorManager.grey7D7D),
              ),
            ],
          ),
          if (value != null) ...[
            Spacer(),
            Row(
              children: [
                if (showCopy == true) ...[
                  SvgPicture.asset(
                    ImageManager.usersManagementCopyIcon,
                    width: 12,
                    height: 12,
                  ),
                  const SizedBox(width: 4),
                ],
                Text(
                  value!,
                  style: StylesManager.styleRegular10(
                    context,
                  ).copyWith(color: ColorManager.greyA8AF),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
