import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/features/parent_home/data/models/parent_child_model.dart';
import 'package:bnan_app/features/parent_home/presentation/views/widgets/parent_children/parent_child_card.dart';
import 'package:flutter/material.dart';

class ParentChildrenPreviewCards extends StatelessWidget {
  const ParentChildrenPreviewCards({
    super.key,
    required this.children,
    required this.loading,
  });
  final List<ParentChildModel> children;
  final bool loading;

  @override
  Widget build(BuildContext context) => AppSkeletonizer(
    isLoading: loading,
    child: Column(
      children: [
        for (var index = 0; index < children.take(2).length; index++) ...[
          ParentChildCard(child: children[index]),
          if (index < children.take(2).length - 1) const SizedBox(height: 8),
        ],
      ],
    ),
  );
}
