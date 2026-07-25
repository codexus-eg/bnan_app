import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/features/student_auth/data/models/package_card_model.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/get_packages_cubit/get_packages_cubit.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/get_packages_cubit/get_packages_state.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/subscription_widgets/subscription_plan_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubscriptionGrid extends StatelessWidget {
  const SubscriptionGrid({
    super.key,
    required this.curriculumId,
    required this.curriculumName,
    this.bottomWidget,
    this.isSliver = true,
  });

  final String curriculumId;
  final String curriculumName;
  final Widget Function(PackageCardModel plan)? bottomWidget;
  final bool isSliver;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetPackagesCubit, GetPackagesState>(
      builder: (context, state) {
        final isLoading = state is GetPackagesLoading;

        if (state is GetPackagesFailure) {
          final errorWidget = Center(
            child: Text(state.errorMessage),
          );

          return isSliver
              ? SliverToBoxAdapter(child: errorWidget)
              : errorWidget;
        }

        final plans = state is GetPackagesSuccess
            ? state.packages
                .map(
                  (package) => PackageCardModel.fromPackage(
                    context: context,
                    package: package,
                  ),
                )
                .toList()
            : PackageCardModel.placeholders(context);

        final grid = AppSkeletonizer(
          isLoading: isLoading,
          child: _PackagesGrid(
            plans: plans,
            curriculumId: curriculumId,
            curriculumName: curriculumName,
            bottomWidget: bottomWidget,
          ),
        );

        return isSliver
            ? SliverToBoxAdapter(child: grid)
            : grid;
      },
    );
  }
}

class _PackagesGrid extends StatelessWidget {
  const _PackagesGrid({
    required this.plans,
    required this.curriculumId,
    required this.curriculumName,
    this.bottomWidget,
  });

  final List<PackageCardModel> plans;
  final String curriculumId;
  final String curriculumName;
  final Widget Function(PackageCardModel plan)? bottomWidget;

  @override
  Widget build(BuildContext context) {
    final rowsCount = (plans.length / 2).ceil();

    return Column(
      children: List.generate(rowsCount, (rowIndex) {
        final firstIndex = rowIndex * 2;
        final secondIndex = firstIndex + 1;

        return Padding(
          padding: EdgeInsets.only(
            bottom: rowIndex == rowsCount - 1 ? 0 : 16,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildCard(
                  plans[firstIndex],
                ),
              ),
              const SizedBox(width: 19),
              if (secondIndex < plans.length)
                Expanded(
                  child: _buildCard(
                    plans[secondIndex],
                  ),
                )
              else
                const Spacer(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildCard(PackageCardModel plan) {
    return SubscriptionPlanCard(
      plan: plan,
      curriculumId: curriculumId,
      curriculumName: curriculumName,
      bottomWidget: bottomWidget?.call(plan),
    );
  }
}