import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/features/shared_profile/presentation/views/widgets/profile_widgets/profile_info_row.dart';
import 'package:bnan_app/features/shared_profile/presentation/views/widgets/profile_widgets/profile_section_card.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class PrivacyCard extends StatelessWidget {
  const PrivacyCard({super.key, required this.onRefresh});

  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return ProfileSectionCard(
      title: S.of(context).privacy,
      children: [
        ProfileInfoRow(
          label: S.of(context).password,
          value: '**********',
          icon: ImageManager.emailIcon,
          onEdit: () async {
            final result = await MyNavigator.goTo<bool>(
              context,
              Routes.updatePassword,
            );

            if (result == true && context.mounted) {
              onRefresh();
            }
          },
        ),
      ],
    );
  }
}
