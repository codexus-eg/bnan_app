import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/auth/presentation/views/widgets/curricula_widgets/curriculum_browse_button.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class CurriculumCard extends StatelessWidget {
  const CurriculumCard({
    super.key,
    required this.title,
    required this.description,
    required this.flag,
    required this.onTap,
  });

  final String title;
  final String description;
  final String flag;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
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
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              Image.asset(flag),
              const SizedBox(width: 41),
              Expanded(
                child: Text(
                  title,
                  style: StylesManager.styleBold18(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            description,
            textAlign: TextAlign.center,
            style: StylesManager.styleRegular14(context),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: CurriculumBrowseButton(
              text: S.of(context).browseSection,
              onPressed: onTap,
            ),
          ),
        ],
      ),
    );
  }
}
