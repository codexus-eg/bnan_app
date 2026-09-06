import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/shared_widget/details_row_section.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/grades_management/data/models/grade_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const Set<String> _kBaccalaureateGradeNames = {
  'تانية ثانوي - طبي - عربي',
  'تانية ثانوي - طبي - لغات',
  'تانية ثانوي - هندسي - عربي',
  'تانية ثانوي - هندسي - لغات',
  'تانية ثانوي - أدبي',
};

const Set<String> _kOldSystemGradeNames = {
  'تانية ثانوي علمي عربي',
  'تانية ثانوي علمي لغات',
  'تانية ثانوي أدبي',
};

class CurriculumGradesCard extends StatelessWidget {
  const CurriculumGradesCard({
    super.key,
    required this.curriculumName,
    required this.grades,
    required this.isInteractive,
    required this.onDeleteGrade,
  });

  final String curriculumName;
  final List<GradeModel> grades;
  final bool isInteractive;
  final void Function(String gradeId) onDeleteGrade;

  @override
  Widget build(BuildContext context) {
    return CustomDetailsWidgetBackground(
      margin: const EdgeInsetsDirectional.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                ImageManager.teacherCurriculm,
                height: 18,
                width: 18,
                colorFilter: const ColorFilter.mode(
                  ColorManager.mainColor14,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  curriculumName,
                  style: StylesManager.styleBold14(
                    context,
                  ).copyWith(color: ColorManager.mainColor14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ..._buildGradeItems(context),
        ],
      ),
    );
  }

  List<Widget> _buildGradeItems(BuildContext context) {
    final generalGrades = <GradeModel>[];
    final baccGrades = <GradeModel>[];
    final oldGrades = <GradeModel>[];

    for (final grade in grades) {
      final norm = grade.name.trim().replaceAll(RegExp(r'\s+'), ' ');
      if (_kBaccalaureateGradeNames.contains(norm)) {
        baccGrades.add(grade);
      } else if (_kOldSystemGradeNames.contains(norm)) {
        oldGrades.add(grade);
      } else {
        generalGrades.add(grade);
      }
    }

    final items = <Widget>[];

    for (final grade in generalGrades) {
      items.add(
        DetailsRowSection(
          iconPath: ImageManager.teacherCurriculm,
          title: grade.name,
          onTap: isInteractive ? () => onDeleteGrade(grade.id) : null,
        ),
      );
    }

    if (baccGrades.isNotEmpty) {
      items.add(
        Padding(
          padding: const EdgeInsetsDirectional.only(
            top: 10,
            bottom: 6,
            start: 4,
          ),
          child: Text(
            'تانية ثانوي بكالوريا',
            style: StylesManager.styleBold12(
              context,
            ).copyWith(color: ColorManager.grey7A7C),
          ),
        ),
      );
      for (final grade in baccGrades) {
        items.add(
          DetailsRowSection(
            iconPath: ImageManager.teacherCurriculm,
            title: grade.name,
            onTap: isInteractive ? () => onDeleteGrade(grade.id) : null,
          ),
        );
      }
    }

    if (oldGrades.isNotEmpty) {
      items.add(
        Padding(
          padding: const EdgeInsetsDirectional.only(
            top: 10,
            bottom: 6,
            start: 4,
          ),
          child: Text(
            'تانية ثانوي نظام قديم',
            style: StylesManager.styleBold12(
              context,
            ).copyWith(color: ColorManager.grey7A7C),
          ),
        ),
      );
      for (final grade in oldGrades) {
        items.add(
          DetailsRowSection(
            iconPath: ImageManager.teacherCurriculm,
            title: grade.name,
            onTap: isInteractive ? () => onDeleteGrade(grade.id) : null,
          ),
        );
      }
    }

    return items;
  }
}
