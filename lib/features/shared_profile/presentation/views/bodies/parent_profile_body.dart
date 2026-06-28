import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/shared_profile/presentation/views/widgets/profile_widgets/custom_systemui.dart';
import 'package:bnan_app/features/shared_profile/presentation/views/widgets/profile_widgets/profile_blue_background.dart';
import 'package:bnan_app/features/shared_profile/presentation/views/widgets/profile_widgets/profile_layout.dart';
import 'package:flutter/material.dart';

class ParentProfileBody extends StatelessWidget {
  const ParentProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomSystemui(
      child: Stack(
        children: [
          const ProfileBlueBackground(),
          SafeArea(
            child: ProfileLayout(
              fullName: 'أ/ خالد عبدالله',
              email: 'khaled@gmail.com',
              phone: '+20 101 655 789',
              roleLabel: 'ولي أمر',
              subtitle: 'ولي أمر ليلى - أحمد',
              onRefresh: () {},
              onLogout: () => _logout(context),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    await SessionManager.instance.clearSession();
    if (!context.mounted) return;
    MyNavigator.goToOffAll(context, Routes.logIn);
  }
}
