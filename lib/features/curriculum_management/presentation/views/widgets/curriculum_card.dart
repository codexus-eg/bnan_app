import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/curriculum_management/data/models/curriculum_model.dart';
import 'package:bnan_app/features/curriculum_management/presentation/views/widgets/curriculum_title.dart';
import 'package:flutter/material.dart';

class CurriculumCard extends StatelessWidget {
  const CurriculumCard({super.key, required this.curriculum});

  final CurriculumModel curriculum;

  @override
  Widget build(BuildContext context) {
    return CustomDetailsWidgetBackground(
      backgroundColor: ColorManager.greyF8F9,
      child: CurriculumTitle(curriculum: curriculum),
    );
  }
}
