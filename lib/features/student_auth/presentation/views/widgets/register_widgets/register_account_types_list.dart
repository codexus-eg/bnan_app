import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/shared_widget/custom_registration_widgets/custom_text_span_login.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/register_widgets/register_account_type_card.dart';
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
          onTap: () => MyNavigator.goTo(context, Routes.studentRegistration),
        ),
        const SizedBox(height: 16),
        RegisterAccountTypeCard(
          title: S.of(context).registerAsParent,
          subtitle: S.of(context).registerAsParentSubtitle,
          icon: ImageManager.parentIcon,
          onTap: () => MyNavigator.goTo(context, Routes.parentRegistration),
        ),
        const SizedBox(height: 16),
        RegisterAccountTypeCard(
          title: S.of(context).applyAsTeacher,
          subtitle: S.of(context).applyAsTeacherSubtitle,
          icon: ImageManager.teacherIcon,
          onTap: () => MyNavigator.goTo(context, Routes.teacherRegistration),
        ),
        const SizedBox(height: 18),
        CustomTextSpanLogin(),
      ],
    );
  }
}
