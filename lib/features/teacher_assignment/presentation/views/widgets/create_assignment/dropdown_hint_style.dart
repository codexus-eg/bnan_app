import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

TextStyle dropdownHintStyle(BuildContext context) {
  return StylesManager.styleRegular16(
    context,
  ).copyWith(color: ColorManager.greyA8AF);
}