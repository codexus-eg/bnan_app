import 'package:bnan_app/core/helper/app_logout.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/core/session/current_user_ui.dart';
import 'package:bnan_app/features/shared_profile/data/models/teacher_profile_response_model.dart';
import 'package:bnan_app/features/shared_profile/presentation/manager/teacher_profile_cubit/teacher_profile_cubit.dart';
import 'package:bnan_app/features/shared_profile/presentation/views/widgets/profile_widgets/custom_teacher_extra_widget.dart';
import 'package:bnan_app/features/shared_profile/presentation/views/widgets/profile_widgets/profile_layout.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class TeacherProfileLayout extends StatelessWidget {
  const TeacherProfileLayout({super.key, required this.profile});

  final TeacherProfileModel profile;

  @override
  Widget build(BuildContext context) {
    return ProfileLayout(
      fullName: profile.user.fullName.trim().isEmpty
          ? CurrentUserUi.name(context)
          : profile.user.fullName,
      email: profile.user.email.trim().isEmpty
          ? SessionManager.instance.userEmail ?? ''
          : profile.user.email,
      phone: profile.phone.trim().isEmpty
          ? SessionManager.instance.userPhone ?? ''
          : profile.phone,
      roleLabel: CurrentUserUi.role(context),
      subtitle: _subtitle(context),
      extraWidget: CustomTeacherExtraWidget(profile: profile),
      onRefresh: () => TeacherProfileCubit.get(context).getTeacherProfile(),
      onLogout: () => _logout(context),
    );
  }

  String _subtitle(BuildContext context) {
    final subjects = _joinNames(profile.subjects);
    final curriculums = _joinNames(profile.curriculums);

    if (subjects.isEmpty && curriculums.isEmpty) {
      return profile.specialization.isEmpty
          ? S.of(context).specialization
          : profile.specialization;
    }

    if (subjects.isEmpty) return curriculums;
    if (curriculums.isEmpty) return subjects;

    return '$subjects\n$curriculums';
  }

  String _joinNames(List<TeacherProfileItemModel> items) {
    return items
        .map((item) => item.name.trim())
        .where((name) => name.isNotEmpty)
        .join(' - ');
  }

  Future<void> _logout(BuildContext context) async {
    await AppLogout.perform(context);
  }
}
