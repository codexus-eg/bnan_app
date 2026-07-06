import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class ClassMetaRow extends StatelessWidget {
  const ClassMetaRow({
    super.key,
    required this.label,
    required this.value,
    this.spacing = false,
  });

  final String label;
  final String value;
  final bool? spacing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: StylesManager.styleMedium10(
              context,
            ).copyWith(color: ColorManager.grey7D7D),
          ),
          if (spacing == true) ...[Spacer()],
          Text(
            value,
            style: StylesManager.styleRegular10(
              context,
            ).copyWith(color: ColorManager.greyA8AF),
          ),
        ],
      ),
    );
  }
}
