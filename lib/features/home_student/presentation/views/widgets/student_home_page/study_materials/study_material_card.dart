import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/home_student/data/models/study_material_model.dart';
import 'package:bnan_app/features/home_student/presentation/views/widgets/student_home_page/study_materials/book_icon.dart';
import 'package:bnan_app/features/home_student/presentation/views/widgets/student_home_page/study_materials/material_info.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class StudyMaterialCard extends StatelessWidget {
  const StudyMaterialCard({super.key, required this.material});

  final StudyMaterialModel material;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.all(8),
      decoration: BoxDecoration(
        color: ColorManager.greyF8F9,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: ColorManager.black.withAlpha((255 * .25).round()),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              BookIcon(icon: material.icon),
              const SizedBox(width: 8),
              Expanded(child: MaterialInfo(material: material)),
            ],
          ),
          const SizedBox(height: 5),

          Text(
            S.of(context).gradeLabel(material.grade),
            style: StylesManager.styleBold12(
              context,
            ).copyWith(color: ColorManager.secondaryColor),
          ),
        ],
      ),
    );
  }
}
