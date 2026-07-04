import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/curriculum_management/data/models/curriculum_model.dart';
import 'package:flutter/material.dart';

class SemesterChip extends StatelessWidget {
  const SemesterChip({
    super.key,
    required this.semester,
    required this.onDelete,
  });

  final SemesterModel semester;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: ColorManager.blueD0DE),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        
        children: [
          InkWell(
            onTap: onDelete,
            child: const Icon(Icons.close, size: 12, color: ColorManager.redD8),
          ),
          const SizedBox(width: 2),
          Flexible(
            child: Text(
              semester.name,
              style: StylesManager.styleRegular10(
                context,
              ).copyWith(color: ColorManager.greyA8AF),
            ),
          ),
        ],
      ),
    );
  }
}
