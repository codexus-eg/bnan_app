import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:flutter/material.dart';

abstract class StylesManager {
  static TextStyle styleRegular10(BuildContext context) {
    return TextStyle(
      fontSize: 10,
      color: ColorManager.mainColor14,
      fontWeight: FontWeight.w400,
    );
  }
   static TextStyle styleRegular12(BuildContext context) {
    return TextStyle(
      fontSize: 12,
      color: ColorManager.greyA8AF,
      fontWeight: FontWeight.w400,
    );
  }
   static TextStyle styleRegular14(BuildContext context) {
    return TextStyle(
      fontSize: 14,
      color: ColorManager.grey7A7C,
      fontWeight: FontWeight.w400,
    );
  }
   static TextStyle styleRegular15(BuildContext context) {
    return TextStyle(
      fontSize: 15,
      color: ColorManager.greyA8AF,
      fontWeight: FontWeight.w400,
    );
  }
  static TextStyle styleRegular16(BuildContext context) {
    return TextStyle(
      fontSize: 16,
      color: ColorManager.mainColor14,
      fontWeight: FontWeight.w400,
    );
  }
  static TextStyle styleLight8(BuildContext context) {
    return TextStyle(
      fontSize: 8,
      color: ColorManager.white,
      fontWeight: FontWeight.w300,
    );
  }
   static TextStyle styleLight12(BuildContext context) {
    return TextStyle(
      fontSize: 12,
      color: ColorManager.greyA8AF,
      fontWeight: FontWeight.w300,
    );
  }
  static TextStyle styleLight14(BuildContext context) {
    return TextStyle(
      fontSize: 14,
      color: ColorManager.mainColor14,
      fontWeight: FontWeight.w300,
    );
  }
   static TextStyle styleMedium14(BuildContext context) {
    return TextStyle(
      fontSize: 14,
      color: ColorManager.white,
      fontWeight: FontWeight.w500,
    );
  }
  static TextStyle styleMedium16(BuildContext context) {
    return TextStyle(
      fontSize: 16,
      color: ColorManager.black,
      fontWeight: FontWeight.w500,
    );
  }
   static TextStyle styleMedium32(BuildContext context) {
    return TextStyle(
      fontSize: 32,
      color: ColorManager.black,
      fontWeight: FontWeight.w500,
    );
  }
   static TextStyle styleBold8(BuildContext context) {
    return TextStyle(
      fontSize: 8,
      color: ColorManager.greyA8AF,
      fontWeight: FontWeight.bold,
    );
  }
  static TextStyle styleBold10(BuildContext context) {
    return TextStyle(
      fontSize: 10,
      color: ColorManager.greyA8AF,
      fontWeight: FontWeight.bold,
    );
  }


  static TextStyle styleBold12(BuildContext context) {
    return TextStyle(
      fontSize: 12,
      color: ColorManager.greyA8AF,
      fontWeight: FontWeight.bold,
    );
  }

   static TextStyle styleBold14(BuildContext context) {
    return TextStyle(
      fontSize: 14,
      color: ColorManager.black,
      fontWeight: FontWeight.bold,
    );
  }
   static TextStyle styleBold16(BuildContext context) {
    return TextStyle(
      fontSize: 16,
      color: ColorManager.white,
      fontWeight: FontWeight.bold,
    );
  }
  static TextStyle styleBold18(BuildContext context) {
    return TextStyle(
      fontSize: 18,
      color: ColorManager.black,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle styleBold20(BuildContext context) {
    return TextStyle(
      fontSize: 20,
      color: ColorManager.mainColor14,
      fontWeight: FontWeight.bold,
    );
  }
  static TextStyle styleBold24(BuildContext context) {
    return TextStyle(
      fontSize: 24,
      color: ColorManager.black,
      fontWeight: FontWeight.bold,
    );
  }
  static TextStyle styleBold28(BuildContext context) {
    return TextStyle(
      fontSize: 28,
      color: ColorManager.mainColor04,
      fontWeight: FontWeight.bold,
    );
  }
}
