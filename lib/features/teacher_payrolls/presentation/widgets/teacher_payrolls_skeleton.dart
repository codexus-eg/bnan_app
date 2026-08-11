import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:flutter/material.dart';

class TeacherPayrollsSkeleton extends StatelessWidget {
  const TeacherPayrollsSkeleton({super.key, this.report = false});
  final bool report;

  @override
  // Placeholder layout only. It never enters feature state.
  Widget build(BuildContext context) => AppSkeletonizer(
    isLoading: true,
    child: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (final height
            in report
                ? const [120.0, 150.0, 130.0, 140.0]
                : const [130.0, 36.0, 180.0, 180.0, 130.0]) ...[
          _SkeletonBlock(height: height),
          const SizedBox(height: 12),
        ],
      ],
    ),
  );
}

class _SkeletonBlock extends StatelessWidget {
  const _SkeletonBlock({required this.height});
  final double height;

  @override
  Widget build(BuildContext context) => CustomDetailsWidgetBackground(
    child: SizedBox(
      height: height,
      width: double.infinity,
      child: const Text('Payroll content placeholder'),
    ),
  );
}
