import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/payments/data/models/discount_preview_request.dart';
import 'package:bnan_app/features/payments/presentation/manager/discount_preview_cubit.dart';
import 'package:bnan_app/features/payments/presentation/manager/discount_preview_state.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/student_registration_widgets/payment_discount_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiscountPreviewSummary extends StatelessWidget {
  const DiscountPreviewSummary({super.key, required this.request});
  final DiscountPreviewRequest? Function() request;

  @override
  Widget build(BuildContext context) {
    try {
      context.read<DiscountPreviewCubit>();
    } on ProviderNotFoundException {
      return const SizedBox.shrink();
    }
    return BlocBuilder<DiscountPreviewCubit, DiscountPreviewState>(
      builder: (context, state) {
        final current = request();
        final isCurrent = current == null
            ? state.fingerprint == null
            : state.fingerprint == current.fingerprint;
        if (state.error != null && isCurrent) {
          return Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              state.error!,
              style: StylesManager.styleRegular14(
                context,
              ).copyWith(color: ColorManager.red),
            ),
          );
        }
        if (current == null || !state.matches(current.fingerprint)) {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: const EdgeInsets.only(top: 16),
          child: PaymentDiscountSummary(
            summary: state.summary!,
            highlightFinalAmount: true,
          ),
        );
      },
    );
  }
}
