import 'package:bnan_app/features/shared_profile/presentation/views/widgets/profile_widgets/contact_info_card.dart';
import 'package:bnan_app/features/shared_profile/presentation/views/widgets/profile_widgets/logout_button.dart';
import 'package:bnan_app/features/shared_profile/presentation/views/widgets/profile_widgets/privacy_card.dart';
import 'package:bnan_app/features/shared_profile/presentation/views/widgets/profile_widgets/profile_header.dart';
import 'package:bnan_app/features/shared_profile/presentation/views/widgets/profile_widgets/profile_info_card.dart';
import 'package:flutter/material.dart';

class ProfileLayout extends StatelessWidget {
  const ProfileLayout({
    super.key,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.roleLabel,
    required this.subtitle,
    required this.onLogout,
    required this.onRefresh,
    this.extraWidget,
  });

  final String fullName;
  final String email;
  final String phone;
  final String roleLabel;
  final String subtitle;
  final Widget? extraWidget;
  final VoidCallback onLogout;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileHeader(role: roleLabel),
        Expanded(
          child: ListView(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 20),
            children: [
              ProfileInfoCard(fullName: fullName, subtitle: subtitle),
              if (extraWidget != null) ...[
                const SizedBox(height: 16),
                extraWidget!,
              ],
              const SizedBox(height: 16),
              ContactInfoCard(
                fullName: fullName,
                email: email,
                phone: phone,
                onRefresh: onRefresh,
              ),
              const SizedBox(height: 16),
              PrivacyCard(onRefresh: onRefresh),
              const SizedBox(height: 16),
              LogoutButton(onTap: onLogout),
            ],
          ),
        ),
      ],
    );
  }
}
