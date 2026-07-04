import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class RegistrationOutlinedButton extends StatelessWidget {
  const RegistrationOutlinedButton({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 25,
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          backgroundColor: ColorManager.white,
          textStyle: StylesManager.styleRegular10(context).copyWith(
            color: ColorManager.mainColor14
          ),
          side: BorderSide(color: ColorManager.blueE3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(title),
      ),
    );
  }
}