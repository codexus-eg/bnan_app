import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/student_profile/presentation/views/widgets/student_wigets/profile_blue_background.dart';
import 'package:bnan_app/features/student_profile/presentation/views/widgets/student_wigets/profile_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StudentProfileBody extends StatelessWidget {
  const StudentProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: ColorManager.mainColor14,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Stack(
        children: [
          ProfileBlueBackground(),
          SafeArea(child: ProfileContent()),
        ],
      ),
    );
  }
}
