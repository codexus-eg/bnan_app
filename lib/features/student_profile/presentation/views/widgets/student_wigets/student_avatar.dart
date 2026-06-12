import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class StudentAvatar extends StatelessWidget {
  const StudentAvatar({super.key, required this.firstName});
  final  String firstName;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 28,
      backgroundColor: const Color(0xffE9C77B),
      child: Text(
        firstName.substring(0,2),
        style: StylesManager.styleBold14(context).copyWith(
          color: ColorManager.mainColor14,
        ),
      ),
    );
  }
}