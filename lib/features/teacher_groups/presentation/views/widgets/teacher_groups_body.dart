import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/features/teacher_groups/data/models/teacher_group_model.dart';
import 'package:bnan_app/features/teacher_groups/presentation/views/widgets/teacher_group_card.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class TeacherGroupsBody extends StatelessWidget {
  const TeacherGroupsBody({super.key});

  static const groups = [
    TeacherGroupModel(
      title: 'الصف الأول الابتدائي',
      studentsCount: 25,
      sectionsCount: 2,
    ),
    TeacherGroupModel(
      title: 'الصف الثاني الابتدائي',
      studentsCount: 25,
      sectionsCount: 2,
    ),
    TeacherGroupModel(
      title: 'الصف الثالث الابتدائي',
      studentsCount: 25,
      sectionsCount: 2,
    ),
    TeacherGroupModel(
      title: 'الصف الرابع الابتدائي',
      studentsCount: 25,
      sectionsCount: 2,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomAppbar(headerText: S.of(context).classes, iconNeeded: false),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsetsDirectional.all(16),
            itemCount: groups.length,
            itemBuilder: (context, index) {
              final group = groups[index];
              return TeacherGroupCard(
                title: group.title,
                needSecondIcon: false,
                iconPath: ImageManager.teacherTraining,
                studentsCount: group.studentsCount,
                secondText: '${group.sectionsCount}',
                secondIconPath: ImageManager.teacherClassRoom,
                onTap: () => MyNavigator.goTo(
                  context,
                  Routes.teacherSections,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}