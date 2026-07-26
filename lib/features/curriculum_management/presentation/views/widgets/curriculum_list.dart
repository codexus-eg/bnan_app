import 'package:bnan_app/features/curriculum_management/data/models/curriculum_model.dart';
import 'package:bnan_app/features/curriculum_management/presentation/views/widgets/curriculum_card.dart';
import 'package:flutter/material.dart';

class CurriculumList extends StatelessWidget {
  const CurriculumList({super.key, required this.curriculums});

  final List<CurriculumModel> curriculums;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 24, 16, 24),
      itemCount: curriculums.length,
      separatorBuilder: (_, _) => const SizedBox(height: 16),
      itemBuilder: (_, index) => CurriculumCard(curriculum: curriculums[index]),
    );
  }
}
