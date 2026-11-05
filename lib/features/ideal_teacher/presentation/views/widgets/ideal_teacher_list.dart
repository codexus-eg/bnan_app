import 'package:bnan_app/features/ideal_teacher/data/models/teacher_ranking_item_model.dart';
import 'package:bnan_app/features/ideal_teacher/presentation/views/widgets/teacher_ranking_card.dart';
import 'package:flutter/material.dart';

class IdealTeacherList extends StatelessWidget {
  const IdealTeacherList({
    super.key,
    required this.ranking,
    required this.selectedIds,
    required this.canModify,
    required this.canSelect,
    required this.onToggle,
    this.scrollController,
  });

  final List<TeacherRankingItemModel> ranking;
  final Set<String> selectedIds;
  final bool canModify, canSelect;
  final ValueChanged<String>? onToggle;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) => ListView.builder(
    controller: scrollController,
    physics: const AlwaysScrollableScrollPhysics(),
    padding: const EdgeInsetsDirectional.fromSTEB(16, 4, 16, 12),
    itemCount: ranking.length,
    itemBuilder: (_, index) {
      final item = ranking[index];
      return TeacherRankingCard(
        key: Key('teacher-ranking-${item.teacherId}'),
        teacher: item,
        selected: selectedIds.contains(item.teacherId),
        canModify: canModify,
        canSelect: canSelect,
        onTap: onToggle == null ? null : () => onToggle!(item.teacherId),
      );
    },
  );
}
