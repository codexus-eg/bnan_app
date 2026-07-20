import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/curriculum_management/data/models/curriculum_model.dart';
import 'package:bnan_app/features/curriculum_management/presentation/views/widgets/add_curriculms_data_title.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CurriculumTitle extends StatelessWidget {
  const CurriculumTitle({super.key, required this.curriculum});
  final CurriculumModel curriculum;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          ImageManager.teacherCurriculm,
          width: 16,
          height: 16,
          colorFilter: ColorFilter.mode(
            ColorManager.mainColor14,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(width: 4),
        AddCurriculmsDataTitle(
          title: curriculum.name,
          subtitle: S.of(context).gradesCount(curriculum.grades.length),
        ),
      ],
    );
  }
}
