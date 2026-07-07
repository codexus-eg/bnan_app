import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class DetailsInfoField extends StatelessWidget {
  const DetailsInfoField({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: EdgeInsetsDirectional.only(
        start: 8,
        end: 8,
        top: 13,
        bottom: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: ColorManager.blueD0DE),
      ),
      child: SelectableText(
        selectionColor: ColorManager.green33B,
        '$label: $value',
        style: StylesManager.styleRegular12(
          context,
        ).copyWith(color: ColorManager.greyA8AF),
      ),
    );
  }
}
