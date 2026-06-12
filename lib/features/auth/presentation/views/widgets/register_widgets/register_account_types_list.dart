import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/features/auth/presentation/views/widgets/register_widgets/register_account_type_card.dart';
import 'package:bnan_app/features/auth/presentation/views/widgets/shared_widgets/auth_switch_text.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class RegisterAccountTypesList extends StatelessWidget {
  const RegisterAccountTypesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RegisterAccountTypeCard(
          title: S.of(context).registerAsStudent,
          subtitle: S.of(context).registerAsStudentSubtitle,
          icon: ImageManager.studentIcon,
          onTap: () {
            MyNavigator.goTo(context, Routes.curriculum);
          },
        ),
        const SizedBox(height: 16),
        RegisterAccountTypeCard(
          title: S.of(context).registerAsParent,
          subtitle: S.of(context).registerAsParentSubtitle,
          icon: ImageManager.parentIcon,
          onTap: () {
            // MyNavigator.goTo(context, Routes.curriculum);
          },
        ),
        const SizedBox(height: 16),
        RegisterAccountTypeCard(
          title: S.of(context).applyAsTeacher,
          subtitle: S.of(context).applyAsTeacherSubtitle,
          icon: ImageManager.teacherIcon,
          onTap: () {},
        ),
        const SizedBox(height: 18),
        AuthSwitchText(
          normalText: S.of(context).alreadyHaveAccount,
          actionText: S.of(context).loginNow,
          onTap: () => MyNavigator.goTo(context, Routes.logIn),
        ),
      ],
    );
  }
}
