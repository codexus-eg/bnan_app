import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/features/shared_profile/data/models/logged_user_model.dart';
import 'package:bnan_app/features/shared_profile/presentation/manager/student_profile_cubit/student_profile_cubit.dart';
import 'package:bnan_app/features/shared_profile/presentation/views/widgets/profile_widgets/profile_info_row.dart';
import 'package:bnan_app/features/shared_profile/presentation/views/widgets/profile_widgets/profile_section_card.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ContactInfoCard extends StatelessWidget {
  final LoggedUserModel loggedUser;

  const ContactInfoCard({super.key, required this.loggedUser});

  @override
  Widget build(BuildContext context) {
    return ProfileSectionCard(
      title: S.of(context).contactInfo,
      children: [
        ProfileInfoRow(
          label: S.of(context).email,
          value: loggedUser.user.email,
          icon: ImageManager.emailIcon,
        ),
        ProfileInfoRow(
          label: S.of(context).userName,
          value: loggedUser.user.fullName,
          icon: ImageManager.annotationTyping,
          onEdit: () async {
            final result = await MyNavigator.goTo<bool>(
              context,
              Routes.updateUserName,
            );

            if (result == true && context.mounted) {
              StudentProfileCubit.get(context).getLoggedUser();
            }
          },
        ),
        ProfileInfoRow(
          label: S.of(context).phoneNumber,
          value: loggedUser.parent?.phone ?? '',
          icon: ImageManager.phoneIcon,
          onEdit: () async {
            final result = await MyNavigator.goTo<bool>(
              context,
              Routes.updatePhone,
            );

            if (result == true && context.mounted) {
              StudentProfileCubit.get(context).getLoggedUser();
            }
          },
        ),
      ],
    );
  }
}