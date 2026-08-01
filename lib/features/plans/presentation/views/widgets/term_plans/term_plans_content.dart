import 'package:bnan_app/features/plans/presentation/manager/get_term_plans/get_term_plans_cubit.dart';
import 'package:bnan_app/features/plans/presentation/manager/get_term_plans/get_term_plans_state.dart';
import 'package:bnan_app/features/plans/presentation/mappers/term_plan_cards_mapper.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/term_plans/term_plans_empty.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/term_plans/term_plans_failure.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/term_plans/term_plans_list.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/term_plans/term_plans_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TermPlansContent extends StatelessWidget {
  const TermPlansContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetTermPlansCubit, GetTermPlansState>(
      builder: (context, state) {
        final cubit = context.read<GetTermPlansCubit>();
        if (state is GetTermPlansFailure) {
          return TermPlansFailure(
            message: state.message,
            onRetry: cubit.refresh,
          );
        }
        if (state is! GetTermPlansSuccess) return const TermPlansSkeleton();
        final cards = mapTermPlanCards(state.response);
        return RefreshIndicator(
          onRefresh: cubit.refresh,
          child: cards.isEmpty
              ? const TermPlansEmpty()
              : TermPlansList(items: cards),
        );
      },
    );
  }
}
