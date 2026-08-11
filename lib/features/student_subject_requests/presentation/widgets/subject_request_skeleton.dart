import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/custom_option_tile.dart';
import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class SubjectRequestSkeleton extends StatelessWidget {
  const SubjectRequestSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return AppSkeletonizer(
      isLoading: true,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ...List.generate(
            3,
            (index) => CustomOptionTile(
              title: s.subjects,
              isSelected: false,
              onTap: () {},
            ),
          ),
          const SizedBox(height: 8),
          CustomTextField(label: s.packages, hintText: s.packages),
          const SizedBox(height: 16),
          CustomTextField(label: s.theRequiredLesson, maxLine: 4),
        ],
      ),
    );
  }
}
