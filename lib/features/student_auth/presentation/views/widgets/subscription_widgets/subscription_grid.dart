import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/features/packages_management/data/models/package_model.dart';
import 'package:bnan_app/features/packages_management/presentation/manager/get_packages_cubit/get_packages_cubit.dart';
import 'package:bnan_app/features/packages_management/presentation/manager/get_packages_cubit/get_packages_state.dart';
import 'package:bnan_app/features/student_auth/data/models/package_card_model.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/subscription_widgets/subscription_plan_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/generated/l10n.dart';

class SubscriptionGrid extends StatelessWidget {
  const SubscriptionGrid({
    super.key,
    required this.curriculumId,
    required this.curriculumName,
    this.bottomWidget,
    this.isSliver = true,
    this.registrationMode,
    this.packageFilter,
    this.planMapper,
    this.selectedPackageId,
  });

  final String curriculumId;
  final String curriculumName;
  final bool isSliver;
  final String? registrationMode;
  final bool Function(PackageModel package)? packageFilter;
  final PackageCardModel Function(BuildContext, PackageModel)? planMapper;
  final String? selectedPackageId;

  final Widget Function(PackageCardModel plan, PackageModel package)?
  bottomWidget;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetPackagesCubit, GetPackagesState>(
      builder: (context, state) {
        final isLoading = state is GetPackagesLoading;

        if (state is GetPackagesFailure) {
          return _wrap(
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(state.message, textAlign: TextAlign.center),
                const SizedBox(height: 12),
                CustomAppButton(
                  text: S.of(context).retry,
                  onPressed: () => curriculumId.isEmpty
                      ? context.read<GetPackagesCubit>().getPackages()
                      : context
                            .read<GetPackagesCubit>()
                            .getPackagesByCurriculum(curriculumId),
                ),
              ],
            ),
          );
        }

        final packages = state is GetPackagesSuccess
            ? state.packages
                  .where((item) => packageFilter?.call(item) ?? true)
                  .toList()
                  .reversed
                  .toList()
            : <PackageModel>[];
        if (state is GetPackagesSuccess && packages.isEmpty) {
          return _wrap(
            SizedBox(
              height: MediaQuery.sizeOf(context).height * .5,
              child: const Center(child: NoDataWidget()),
            ),
          );
        }

        final plans = state is GetPackagesSuccess
            ? packages
                  .map(
                    (package) =>
                        planMapper?.call(context, package) ??
                        PackageCardModel.fromPackage(
                          context: context,
                          package: package,
                        ),
                  )
                  .toList()
            : PackageCardModel.placeholders(context);

        final grid = Padding(
          padding: const EdgeInsets.only(top: 8),
          child: AppSkeletonizer(
            isLoading: isLoading,
            child: PackagesGrid(
              plans: plans,
              packages: packages,
              curriculumId: curriculumId,
              curriculumName: curriculumName,
              registrationMode: registrationMode,
              bottomWidget: bottomWidget,
              selectedPackageId: selectedPackageId,
            ),
          ),
        );

        return _wrap(grid);
      },
    );
  }

  Widget _wrap(Widget child) {
    return isSliver ? SliverToBoxAdapter(child: child) : child;
  }
}

class PackagesGrid extends StatelessWidget {
  const PackagesGrid({
    super.key,
    required this.plans,
    required this.packages,
    required this.curriculumId,
    required this.curriculumName,
    this.bottomWidget,
    this.registrationMode,
    this.selectedPackageId,
  });

  final List<PackageCardModel> plans;
  final List<PackageModel> packages;
  final String curriculumId;
  final String curriculumName;
  final String? registrationMode;
  final String? selectedPackageId;

  final Widget Function(PackageCardModel plan, PackageModel package)?
  bottomWidget;

  @override
  Widget build(BuildContext context) {
    final rowsCount = (plans.length / 2).ceil();

    return Column(
      children: List.generate(rowsCount, (rowIndex) => _buildRow(rowIndex)),
    );
  }

  Widget _buildRow(int rowIndex) {
    final firstIndex = rowIndex * 2;
    final secondIndex = firstIndex + 1;
    final rowsCount = (plans.length / 2).ceil();

    return Padding(
      padding: EdgeInsets.only(bottom: rowIndex == rowsCount - 1 ? 0 : 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _buildCard(firstIndex)),
          const SizedBox(width: 19),
          if (secondIndex < plans.length)
            Expanded(child: _buildCard(secondIndex))
          else
            const Spacer(),
        ],
      ),
    );
  }

  Widget _buildCard(int index) {
    final plan = plans[index];

    return SubscriptionPlanCard(
      plan: plan,
      curriculumId: curriculumId,
      curriculumName: curriculumName,
      registrationMode: registrationMode,
      isSelected: plan.id == selectedPackageId,
      bottomWidget: index < packages.length
          ? bottomWidget?.call(plan, packages[index])
          : null,
    );
  }
}
