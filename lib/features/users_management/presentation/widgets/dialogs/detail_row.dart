import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/core/shared_widget/copy_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DetailRow extends StatelessWidget {
  const DetailRow({
    super.key,
    required this.label,
    this.value,
    required this.icon,
    this.showCopy = false,
    this.onCopy,
  });

  final String label;
  final String? value;
  final String icon;
  final bool? showCopy;
  final VoidCallback? onCopy;

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
            const SizedBox(width: 8),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (showCopy == true) CopyIconButton(onPressed: onCopy),
                  Flexible(
                    child: Text(
                      value!,
                      textAlign: TextAlign.end,
                      style: StylesManager.styleRegular10(
                        context,
                      ).copyWith(color: ColorManager.greyA8AF),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
