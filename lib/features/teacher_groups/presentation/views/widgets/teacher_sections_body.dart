import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/features/teacher_groups/data/models/teacher_section_model.dart';
import 'package:bnan_app/features/teacher_groups/presentation/views/widgets/teacher_group_card.dart';
import 'package:flutter/material.dart';

class TeacherSectionsBody extends StatelessWidget {
  const TeacherSectionsBody({super.key});

  static const sections = [
    TeacherSectionModel(
      title: 'الفصل الثالث أ',
      studentsCount: 25,
      subjectName: 'الرياضيات',
    ),
    TeacherSectionModel(
      title: 'الفصل الثالث ب',
      studentsCount: 25,
      subjectName: 'الرياضيات',
    ),
    TeacherSectionModel(
      title: 'الفصل الرابع أ',
      studentsCount: 25,
      subjectName: 'هندسة',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
            padding: const EdgeInsetsDirectional.all(16),
      itemCount: sections.length,
      itemBuilder: (context, index) {
        final section = sections[index];
        return TeacherGroupCard(
          title: section.title,
          needSecondIcon: true,
          iconPath: ImageManager.teacherClassRoom,
          studentsCount: section.studentsCount,
          secondText: section.subjectName,
          secondIconPath: ImageManager.teacherBookOneIcon,
          onTap: () {},
        );
      },
    );
  }
}