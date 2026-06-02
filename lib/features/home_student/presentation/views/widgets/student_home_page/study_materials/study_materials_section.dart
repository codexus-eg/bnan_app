import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/features/home_student/data/models/study_material_model.dart';
import 'package:bnan_app/features/home_student/presentation/views/widgets/student_home_page/study_materials/study_material_card.dart';
import 'package:bnan_app/features/home_student/presentation/views/widgets/shared_widgets/material_header.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class StudyMaterialsSection extends StatelessWidget {
  const StudyMaterialsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final materials = [
      StudyMaterialModel(
        title: S.of(context).math,
        teacherName: S.of(context).teacherSarahShort,
        grade: '92',
        icon: ImageManager.bookIcon,
      ),
      StudyMaterialModel(
        title: S.of(context).math,
        teacherName: S.of(context).teacherSarahShort,
        grade: '92',
        icon: ImageManager.bookIcon,
      ),
      StudyMaterialModel(
        title: S.of(context).arabicLanguage,
        teacherName: S.of(context).teacherSarahShort,
        grade: '92',
        icon: ImageManager.bookIcon,
      ),
      StudyMaterialModel(
        title: S.of(context).math,
        teacherName: S.of(context).teacherSarahShort,
        grade: '92',
        icon: ImageManager.bookIcon,
      ),
    ];

    return Column(
      children: [
        MaterialsHeader(onViewAllTap: () {}, header: S.of(context).studyMaterials),
        GridView.builder(
          itemCount: materials.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 21,
            childAspectRatio:161/96.5,
          ),
          itemBuilder: (context, index) {
            return StudyMaterialCard(material: materials[index]);
          },
        ),
      ],
    );
  }
}
