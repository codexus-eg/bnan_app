import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/features/discount_codes/data/models/discount_code_model.dart';
import 'package:bnan_app/features/discount_codes/presentation/manager/discount_codes_cubit.dart';
import 'package:bnan_app/features/discount_codes/presentation/manager/discount_codes_state.dart';
import 'package:bnan_app/features/discount_codes/presentation/views/widgets/discount_code_card.dart';
import 'package:bnan_app/features/users_management/presentation/widgets/users_management_failure.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiscountCodesContent extends StatelessWidget {
  const DiscountCodesContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiscountCodesCubit, DiscountCodesState>(
      builder: (context, state) {
        if (state is DiscountCodesFailure) {
          return UsersManagementFailure(
            message: state.message,
            onRetry: context.read<DiscountCodesCubit>().load,
          );
        }
        final loading =
            state is DiscountCodesInitial || state is DiscountCodesLoading;
        final codes = state is DiscountCodesSuccess ? state.codes : _mockCodes;
        if (!loading && codes.isEmpty) return _empty(context);
        return AppSkeletonizer(
          isLoading: loading,
          child: RefreshIndicator(
            onRefresh: context.read<DiscountCodesCubit>().load,
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: codes.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (_, index) =>
                  DiscountCodeCard(code: codes[index], enabled: !loading),
            ),
          ),
        );
      },
    );
  }

  Widget _empty(BuildContext context) => RefreshIndicator(
    onRefresh: context.read<DiscountCodesCubit>().load,
    child: ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: 400,
          child: NoDataWidget(title: S.of(context).noDiscountCodes),
        ),
      ],
    ),
  );
}

const _mockCodes = [
  DiscountCodeModel(
    id: '',
    code: 'SUMMER20',
    type: DiscountCodeType.dateRange,
    percentage: 20,
    isActive: true,
  ),
  DiscountCodeModel(
    id: '',
    code: 'FAMILY25',
    type: DiscountCodeType.children,
    percentage: 25,
    isActive: true,
    childrenCount: 3,
  ),
];
