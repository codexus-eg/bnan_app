import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/auth/data/models/curriculum_card_model.dart';
import 'package:bnan_app/features/auth/presentation/views/widgets/curricula_widgets/curriculum_browse_button.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class CurriculumCard extends StatelessWidget {
  const CurriculumCard({
    super.key,
    required this.curriculumCard,
    required this.onTap,
  });

  final CurriculumCardModel curriculumCard;
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildIcon(),
              const SizedBox(width: 41),
              Expanded(
                child: Text(
                  curriculumCard.title,
                  style: StylesManager.styleBold18(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            curriculumCard.description,
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
  Widget _buildIcon() {
  if (curriculumCard.iconUrl.isEmpty) {
    return const Icon(Icons.image_outlined, size: 28);
  }

  return Image.network(
    curriculumCard.iconUrl,
    width: 53,
    height: 36,
    errorBuilder: (context, error, stackTrace) {
      return const Icon(Icons.image_not_supported_outlined, size: 28);
    },
  );
}
}
