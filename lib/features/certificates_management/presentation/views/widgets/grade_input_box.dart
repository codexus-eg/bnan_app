import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GradeInputBox extends StatelessWidget {
  const GradeInputBox({
    super.key,
    required this.controller,
    this.isLight = false,
  });

  final TextEditingController controller;
  final bool isLight;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      style: StylesManager.styleBold14(context).copyWith(
        color: isLight
            ? ColorManager.blue7ED
            : ColorManager.mainColor14,
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        border: _border(),
        enabledBorder: _border(),
        focusedBorder: _border(),
      ),
    );
  }

  OutlineInputBorder _border() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: ColorManager.blueD0DE,
      ),
    );
  }
}