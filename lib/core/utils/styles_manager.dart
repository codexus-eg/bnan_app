import 'package:bnan_app/core/constants/constant_fonts.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:flutter/material.dart';

abstract class StylesManager {
  static const String fontSans = Constants.thmanyahSans;
  static const String fontSerifDisplay = Constants.thmanyahSerifDisplay;
  static const String fontSerifText = Constants.thmanyahSerifText;

  // Body Text & Paragraphs (descriptions, subtitles, regular text <= 16px) -> thmanyahSerifText
  static TextStyle styleRegular10(BuildContext context) {
    return const TextStyle(
      fontSize: 10,
      color: ColorManager.mainColor14,
      fontWeight: FontWeight.w400,
      fontFamily: fontSerifText,
    );
  }

  static TextStyle styleRegular12(BuildContext context) {
    return const TextStyle(
      fontSize: 12,
      color: ColorManager.greyA8AF,
      fontWeight: FontWeight.w400,
      fontFamily: fontSerifText,
    );
  }

  static TextStyle styleRegular14(BuildContext context) {
    return const TextStyle(
      fontSize: 14,
      color: ColorManager.grey7A7C,
      fontWeight: FontWeight.w400,
      fontFamily: fontSerifText,
    );
  }

  static TextStyle styleRegular15(BuildContext context) {
    return const TextStyle(
      fontSize: 15,
      color: ColorManager.greyA8AF,
      fontWeight: FontWeight.w400,
      fontFamily: fontSerifText,
    );
  }

  static TextStyle styleRegular16(BuildContext context) {
    return const TextStyle(
      fontSize: 16,
      color: ColorManager.mainColor14,
      fontWeight: FontWeight.w400,
      fontFamily: fontSerifText,
    );
  }

  static TextStyle styleLight8(BuildContext context) {
    return const TextStyle(
      fontSize: 8,
      color: ColorManager.white,
      fontWeight: FontWeight.w300,
      fontFamily: fontSerifText,
    );
  }

  static TextStyle styleLight12(BuildContext context) {
    return const TextStyle(
      fontSize: 12,
      color: ColorManager.greyA8AF,
      fontWeight: FontWeight.w300,
      fontFamily: fontSerifText,
    );
  }

  static TextStyle styleLight14(BuildContext context) {
    return const TextStyle(
      fontSize: 14,
      color: ColorManager.mainColor14,
      fontWeight: FontWeight.w300,
      fontFamily: fontSerifText,
    );
  }

  static TextStyle styleMedium10(BuildContext context) {
    return const TextStyle(
      fontSize: 10,
      color: ColorManager.grey7D7D,
      fontWeight: FontWeight.w500,
      fontFamily: fontSerifText,
    );
  }

  static TextStyle styleMedium14(BuildContext context) {
    return const TextStyle(
      fontSize: 14,
      color: ColorManager.white,
      fontWeight: FontWeight.w500,
      fontFamily: fontSerifText,
    );
  }

  static TextStyle styleMedium16(BuildContext context) {
    return const TextStyle(
      fontSize: 16,
      color: ColorManager.black,
      fontWeight: FontWeight.w500,
      fontFamily: fontSerifText,
    );
  }

  static TextStyle styleBold8(BuildContext context) {
    return const TextStyle(
      fontSize: 8,
      color: ColorManager.greyA8AF,
      fontWeight: FontWeight.bold,
      fontFamily: fontSerifText,
    );
  }

  static TextStyle styleBold10(BuildContext context) {
    return const TextStyle(
      fontSize: 10,
      color: ColorManager.greyA8AF,
      fontWeight: FontWeight.bold,
      fontFamily: fontSerifText,
    );
  }

  static TextStyle styleBold12(BuildContext context) {
    return const TextStyle(
      fontSize: 12,
      color: ColorManager.greyA8AF,
      fontWeight: FontWeight.bold,
      fontFamily: fontSerifText,
    );
  }

  static TextStyle styleBold14(BuildContext context) {
    return const TextStyle(
      fontSize: 14,
      color: ColorManager.black,
      fontWeight: FontWeight.bold,
      fontFamily: fontSerifText,
    );
  }

  static TextStyle styleBold16(BuildContext context) {
    return const TextStyle(
      fontSize: 16,
      color: ColorManager.white,
      fontWeight: FontWeight.bold,
      fontFamily: fontSerifText,
    );
  }

  // Headings & Titles (App bar titles, Section Headers, large text >= 18px) -> thmanyahSerifDisplay
  static TextStyle styleBold18(BuildContext context) {
    return const TextStyle(
      fontSize: 18,
      color: ColorManager.black,
      fontWeight: FontWeight.bold,
      fontFamily: fontSerifDisplay,
    );
  }

  static TextStyle styleBold20(BuildContext context) {
    return const TextStyle(
      fontSize: 20,
      color: ColorManager.mainColor14,
      fontWeight: FontWeight.bold,
      fontFamily: fontSerifDisplay,
    );
  }

  static TextStyle styleBold24(BuildContext context) {
    return const TextStyle(
      fontSize: 24,
      color: ColorManager.black,
      fontWeight: FontWeight.bold,
      fontFamily: fontSerifDisplay,
    );
  }

  static TextStyle styleBold28(BuildContext context) {
    return const TextStyle(
      fontSize: 28,
      color: ColorManager.mainColor04,
      fontWeight: FontWeight.bold,
      fontFamily: fontSerifDisplay,
    );
  }

  static TextStyle styleMedium32(BuildContext context) {
    return const TextStyle(
      fontSize: 32,
      color: ColorManager.black,
      fontWeight: FontWeight.w500,
      fontFamily: fontSerifDisplay,
    );
  }

  // Numbers, English Text, & UI Elements (Dates, Prices, Buttons, Badges) -> thmanyahSans
  static TextStyle styleButton(
    BuildContext context, {
    double fontSize = 16,
    Color? color,
    FontWeight fontWeight = FontWeight.bold,
  }) {
    return TextStyle(
      fontSize: fontSize,
      color: color ?? ColorManager.white,
      fontWeight: fontWeight,
      fontFamily: fontSans,
    );
  }

  static TextStyle styleBadge(
    BuildContext context, {
    double fontSize = 12,
    Color? color,
    FontWeight fontWeight = FontWeight.w500,
  }) {
    return TextStyle(
      fontSize: fontSize,
      color: color ?? ColorManager.white,
      fontWeight: fontWeight,
      fontFamily: fontSans,
    );
  }

  static TextStyle styleNumber(
    BuildContext context, {
    double fontSize = 14,
    Color? color,
    FontWeight fontWeight = FontWeight.w400,
  }) {
    return TextStyle(
      fontSize: fontSize,
      color: color ?? ColorManager.black,
      fontWeight: fontWeight,
      fontFamily: fontSans,
    );
  }

  static TextStyle stylePrice(
    BuildContext context, {
    double fontSize = 16,
    Color? color,
    FontWeight fontWeight = FontWeight.bold,
  }) {
    return TextStyle(
      fontSize: fontSize,
      color: color ?? ColorManager.black,
      fontWeight: fontWeight,
      fontFamily: fontSans,
    );
  }

  static TextStyle styleDate(
    BuildContext context, {
    double fontSize = 12,
    Color? color,
    FontWeight fontWeight = FontWeight.w400,
  }) {
    return TextStyle(
      fontSize: fontSize,
      color: color ?? ColorManager.grey7A7C,
      fontWeight: fontWeight,
      fontFamily: fontSans,
    );
  }

  static TextStyle styleSans(
    BuildContext context, {
    required double fontSize,
    Color? color,
    FontWeight fontWeight = FontWeight.w400,
  }) {
    return TextStyle(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
      fontFamily: fontSans,
    );
  }
}

extension TextStyleThmanyahX on TextStyle {
  TextStyle get sans => copyWith(fontFamily: StylesManager.fontSans);
  TextStyle get serifDisplay =>
      copyWith(fontFamily: StylesManager.fontSerifDisplay);
  TextStyle get serifText => copyWith(fontFamily: StylesManager.fontSerifText);
}
