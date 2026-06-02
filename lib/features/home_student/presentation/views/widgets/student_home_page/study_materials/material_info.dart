import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/home_student/data/models/study_material_model.dart';
import 'package:flutter/material.dart';

class MaterialInfo extends StatelessWidget {
  const MaterialInfo({super.key, required this.material});

  final StudyMaterialModel material;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          material.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: StylesManager.styleBold16(context).copyWith(
            color: ColorManager.mainColor14,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          material.teacherName,
          style: StylesManager.styleRegular14(context).copyWith(
            color: ColorManager.greyA8AF,
          ),
        ),
       
      ],
    );
  }
}