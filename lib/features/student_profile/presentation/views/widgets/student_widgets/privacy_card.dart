import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/features/student_profile/presentation/views/widgets/student_widgets/profile_info_row.dart';
import 'package:bnan_app/features/student_profile/presentation/views/widgets/student_widgets/profile_section_card.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class PrivacyCard extends StatelessWidget {
  const PrivacyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileSectionCard(
      title: S.of(context).privacy,
      children: [
        ProfileInfoRow(
          label: S.of(context).password,
          value: '**********',
          icon: ImageManager.emailIcon,
          onEdit: () {
            MyNavigator.goTo(context, Routes.updatePassword);
          },
        ),
      ],
    );
  }
}
