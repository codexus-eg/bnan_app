import 'package:bnan_app/features/shared_profile/presentation/views/widgets/profile_widgets/custom_systemui.dart';
import 'package:bnan_app/features/shared_profile/presentation/views/widgets/profile_widgets/profile_blue_background.dart';
import 'package:bnan_app/features/shared_profile/presentation/views/widgets/profile_widgets/profile_content.dart';
import 'package:flutter/material.dart';

class StudentProfileBody extends StatelessWidget {
  const StudentProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomSystemui(
      child: Stack(
        children: [
          ProfileBlueBackground(),
          SafeArea(child: ProfileContent()),
        ],
      ),
    );
  }
}
