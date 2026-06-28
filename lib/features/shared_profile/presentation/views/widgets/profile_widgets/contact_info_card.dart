import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/features/shared_profile/presentation/views/widgets/profile_widgets/profile_info_row.dart';
import 'package:bnan_app/features/shared_profile/presentation/views/widgets/profile_widgets/profile_section_card.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ContactInfoCard extends StatelessWidget {
  const ContactInfoCard({
    super.key,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.onRefresh,
  });

  final String fullName;
  final String email;
  final String phone;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return ProfileSectionCard(
      title: S.of(context).contactInfo,
      children: [
        ProfileInfoRow(
          label: S.of(context).email,
          value: email,
          icon: ImageManager.emailIcon,
        ),
        ProfileInfoRow(
          label: S.of(context).userName,
          value: fullName,
          icon: ImageManager.annotationTyping,
          onEdit: () => _edit(context, Routes.updateUserName),
        ),
        ProfileInfoRow(
          label: S.of(context).phoneNumber,
          value: phone,
          icon: ImageManager.phoneIcon,
          onEdit: () => _edit(context, Routes.updatePhone),
        ),
      ],
    );
  }

  Future<void> _edit(BuildContext context, String route) async {
    final result = await MyNavigator.goTo<bool>(context, route);

    if (result == true && context.mounted) {
      onRefresh();
    }
  }
}
