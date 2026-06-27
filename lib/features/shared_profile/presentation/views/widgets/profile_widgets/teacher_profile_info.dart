import 'package:bnan_app/core/models/home_state_model.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TeacherProfileInfo extends StatelessWidget {
  const TeacherProfileInfo({super.key, required this.profileInfo});
  final HomeStateModel profileInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 2, vertical: 4),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          SvgPicture.asset(profileInfo.icon, height: 24, width: 24),
          SizedBox(height: 8),
          Text(
            profileInfo.value,
            style: StylesManager.styleBold16(
              context,
            ).copyWith(color: ColorManager.black),
          ),
          SizedBox(height: 8),
          Text(
            profileInfo.title,
            style: StylesManager.styleRegular14(
              context,
            ).copyWith(color: ColorManager.greyA8AF,letterSpacing: 0),
          ),
        ],
      ),
    );
  }
}
