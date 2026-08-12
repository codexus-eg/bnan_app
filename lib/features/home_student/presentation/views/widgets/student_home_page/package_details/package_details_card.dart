import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/features/dashboard/data/models/student_dashboard_model.dart';
import 'package:bnan_app/features/home_student/presentation/views/widgets/student_home_page/package_details/package_details_card_content.dart';
import 'package:flutter/material.dart';

class PackageDetailsCard extends StatelessWidget {
  const PackageDetailsCard({
    super.key,
    required this.subscription,
    required this.loading,
  });
  final DashboardSubscription? subscription;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final value = subscription;
    if (value == null) return const SizedBox.shrink();
    return AppSkeletonizer(
      isLoading: loading,
      child: PackageDetailsCardContent(subscription: value),
    );
  }
}
