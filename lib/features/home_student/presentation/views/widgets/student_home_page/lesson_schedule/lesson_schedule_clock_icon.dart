import 'package:bnan_app/core/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LessonScheduleClockIcon extends StatelessWidget {
  const LessonScheduleClockIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(ImageManager.clockTenIcon);
  }
}