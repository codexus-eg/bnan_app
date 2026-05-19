
import 'package:bnan_app/core/constants/constant_fonts.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:flutter/material.dart';

abstract class ThemeHelper {
  static ThemeData getTheme() {
    return ThemeData(
      fontFamily: Constants.appFont,
      scaffoldBackgroundColor: ColorManager.backGround,
      appBarTheme: const AppBarTheme(
        scrolledUnderElevation: 0,
        elevation: 0,
        backgroundColor: ColorManager.backGround,
        
      ),
      
    );
  }
}
