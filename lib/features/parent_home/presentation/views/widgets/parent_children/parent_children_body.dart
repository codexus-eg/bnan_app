import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/parent_home/data/models/parent_child_model.dart';
import 'package:bnan_app/features/parent_home/presentation/views/widgets/parent_children/parent_child_card.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ParentChildrenBody extends StatelessWidget {
  const ParentChildrenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAppbar(headerText: S.of(context).parentYourChildren,iconNeeded: false),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: children.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return ParentChildCard(parentChildModel: children[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}