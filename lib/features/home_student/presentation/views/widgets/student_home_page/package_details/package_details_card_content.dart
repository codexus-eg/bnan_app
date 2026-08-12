import 'package:bnan_app/core/shared_widget/home_card_widget.dart';
import 'package:bnan_app/core/shared_widget/progress_line.dart';
import 'package:bnan_app/features/dashboard/data/models/student_dashboard_model.dart';
import 'package:bnan_app/features/home_student/presentation/views/widgets/student_home_page/package_details/card_header.dart';
import 'package:bnan_app/features/home_student/presentation/views/widgets/student_home_page/package_details/progress_info.dart';
import 'package:flutter/material.dart';

class PackageDetailsCardContent extends StatelessWidget {
  const PackageDetailsCardContent({super.key, required this.subscription});
  final DashboardSubscription subscription;

  @override
  Widget build(BuildContext context) => HomeCardWidget(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CardHeader(isActive: subscription.isActive),
        const SizedBox(height: 8),
        ProgressInfo(
          remainingHours: subscription.remainingHours,
          usedHours: subscription.usedHours,
          totalHours: subscription.totalHours,
          isDaysPackage: subscription.packageType == 'days',
        ),
        const SizedBox(height: 4),
        ProgressLine(
          value: (subscription.progressPercentage / 100).clamp(0, 1),
        ),
        const SizedBox(height: 8),
      ],
    ),
  );
}
