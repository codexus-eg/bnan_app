import 'package:bnan_app/features/packages_management/data/models/egyptian_package_policy.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/subscription_widgets/subscription_grid.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/subscription_widgets/subscription_header.dart';
import 'package:flutter/material.dart';

class SubscriptionBody extends StatelessWidget {
  const SubscriptionBody({
    super.key,
    required this.curriculumId,
    required this.curriculumName,
    this.registrationMode,
  });
  final String curriculumId;
  final String curriculumName;
  final String? registrationMode;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: SubscriptionHeader()),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          SliverPadding(
            padding: EdgeInsetsDirectional.only(start: 14, end: 18),
            sliver: SubscriptionGrid(
              curriculumId: curriculumId,
              curriculumName: curriculumName,
              registrationMode: registrationMode,
              packageFilter: registrationMode == 'egyptian'
                  ? EgyptianPackagePolicy.isValid
                  : null,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }
}
