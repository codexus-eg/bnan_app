import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/features/shared_profile/data/models/logged_user_model.dart';
import 'package:bnan_app/features/shared_profile/presentation/views/widgets/profile_widgets/profile_info_row.dart';
import 'package:bnan_app/features/shared_profile/presentation/views/widgets/profile_widgets/profile_section_card.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class StudentProfileDetails extends StatelessWidget {
  const StudentProfileDetails({super.key, required this.user});

  final LoggedUserModel user;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final rows = <Widget>[];
    void add(String label, String? value) {
      if (value?.trim().isNotEmpty != true) return;
      rows.add(
        ProfileInfoRow(
          label: label,
          value: value!,
          icon: ImageManager.bookIcon,
        ),
      );
    }

    add(s.curriculum, user.curriculumName ?? user.curriculum);
    add(s.grade, user.grade?.name);
    add(s.subjects, user.subjects.join(' - '));
    add(s.registrationMode, _mode(s));
    return rows.isEmpty
        ? const SizedBox.shrink()
        : ProfileSectionCard(title: s.personalProfile, children: rows);
  }

  String? _mode(S s) => switch (user.studentMode?.toLowerCase()) {
    'egyptian' => s.egyptian,
    'gulf' => s.gulfCurriculum,
    _ => null,
  };
}
