import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:flutter/material.dart';

class ProfileBlueBackground extends StatelessWidget {
  const ProfileBlueBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height*(299/812),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: ColorManager.mainColor14,
        borderRadius: BorderRadiusDirectional.only(
          bottomStart: Radius.circular(25),
          bottomEnd: Radius.circular(25),
        ),
      ),
    );
  }
}