import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/manager/read_only/read_only_weekly_evaluations_cubit.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReadOnlyFailureFeedback extends StatelessWidget {
  const ReadOnlyFailureFeedback({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(message, textAlign: TextAlign.center),
        const SizedBox(height: 16),
        SizedBox(
          width: 180,
          child: CustomAppButton(
            key: const Key('readOnlyRetry'),
            text: S.of(context).retry,
            onPressed: context.read<ReadOnlyWeeklyEvaluationsCubit>().retry,
          ),
        ),
      ],
    ),
  );
}
