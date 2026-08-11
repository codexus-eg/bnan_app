import 'package:bnan_app/features/parent_home/data/models/parent_child_model.dart';
import 'package:bnan_app/features/parent_home/presentation/views/widgets/parent_children/parent_child_card.dart';
import 'package:flutter/material.dart';

const parentChildrenSkeletonItems = [
  ParentChildModel(
    fullName: 'Child name',
    classroom: ParentChildClassroomModel(
      name: 'Classroom',
      grade: ParentChildGradeModel(name: 'Grade'),
    ),
  ),
  ParentChildModel(
    fullName: 'Child name',
    classroom: ParentChildClassroomModel(
      name: 'Classroom',
      grade: ParentChildGradeModel(name: 'Grade'),
    ),
  ),
  ParentChildModel(
    fullName: 'Child name',
    classroom: ParentChildClassroomModel(
      name: 'Classroom',
      grade: ParentChildGradeModel(name: 'Grade'),
    ),
  ),
];

class ParentChildrenList extends StatelessWidget {
  const ParentChildrenList({
    super.key,
    required this.children,
    this.onChildTap,
  });

  final List<ParentChildModel> children;
  final ValueChanged<ParentChildModel>? onChildTap;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: children.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, index) => ParentChildCard(
        child: children[index],
        onTap: onChildTap == null ? null : () => onChildTap!(children[index]),
      ),
    );
  }
}
