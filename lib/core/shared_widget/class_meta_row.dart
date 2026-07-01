import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class ClassMetaRow extends StatelessWidget {
  const ClassMetaRow({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 4),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '$label: ',
              style: StylesManager.styleMedium10(
                context,
              ).copyWith(color: ColorManager.grey7D7D),
            ),
            TextSpan(
              text: value,
              style: StylesManager.styleRegular10(
                context,
              ).copyWith(color: ColorManager.greyA8AF),
            ),
          ],
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}