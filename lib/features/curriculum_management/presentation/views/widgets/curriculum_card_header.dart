import 'package:bnan_app/features/curriculum_management/data/models/curriculum_model.dart';
import 'package:bnan_app/features/curriculum_management/presentation/views/widgets/curriculum_title.dart';
import 'package:bnan_app/features/curriculum_management/presentation/views/widgets/delete_icon_button.dart';
import 'package:flutter/material.dart';

class CurriculumCardHeader extends StatelessWidget {
  const CurriculumCardHeader({
    super.key,
    required this.curriculum,
    required this.isExpanded,
    required this.onToggle,
    required this.onDelete,
  });

  final CurriculumModel curriculum;
  final bool isExpanded;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CurriculumTitle(
            curriculum: curriculum,
            isExpanded: isExpanded,
            onToggle: onToggle,
          ),
        ),
        DeleteIconButton(onTap: onDelete,size: 20,),
      ],
    );
  }
}
