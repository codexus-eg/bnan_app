import 'package:bnan_app/features/shared_profile/presentation/views/bodies/teacher_profile_content.dart';
import 'package:bnan_app/features/shared_profile/presentation/views/widgets/profile_widgets/custom_systemui.dart';
import 'package:bnan_app/features/shared_profile/presentation/views/widgets/profile_widgets/profile_blue_background.dart';
import 'package:flutter/material.dart';

class TeacherProfileBody extends StatelessWidget {
  const TeacherProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomSystemui(
      child: Stack(
        children: [
          ProfileBlueBackground(),
          SafeArea(child: TeacherProfileContent()),
        ],
      ),
    );
  }
}
