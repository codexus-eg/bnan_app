import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/parent_children/presentation/manager/parent_add_child_cubit/parent_add_child_cubit.dart';
import 'package:bnan_app/features/parent_children/presentation/manager/parent_add_child_cubit/parent_add_child_state.dart';
import 'package:bnan_app/features/parent_children/data/models/parent_flow_result.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParentAddChildResult extends StatelessWidget {
  const ParentAddChildResult({super.key, required this.state});

  final ParentAddChildState state;

  @override
  Widget build(BuildContext context) {
    final processing = state.phase == ParentAddChildPhase.processingPayment;
    final success = state.phase == ParentAddChildPhase.completed;
    final pending = state.phase == ParentAddChildPhase.pendingReview;
    final unknown = state.phase == ParentAddChildPhase.paymentStatusUnknown;
    final message = processing
        ? S.of(context).parentPaymentProcessing
        : pending
        ? S.of(context).registrationRequestSuccessMessage
        : success
        ? S.of(context).parentChildAddedSuccessfully
        : unknown
        ? S.of(context).parentPaymentStatusTimeout
        : state.errorMessage ?? S.of(context).parentAddChildFailed;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (processing)
              const CircularProgressIndicator(color: ColorManager.mainColor14),
            if (processing) const SizedBox(height: 20),
            Text(
              message,
              textAlign: TextAlign.center,
              style: StylesManager.styleBold16(context),
            ),
            const SizedBox(height: 24),
            if (pending || success)
              CustomAppButton(
                text: S.of(context).parentBackToChildren,
                onPressed: () => MyNavigator.pop(
                  context,
                  pending
                      ? ParentFlowResult.pendingReview
                      : ParentFlowResult.completed,
                ),
              ),
            if (unknown) ...[
              CustomAppButton(
                text: S.of(context).parentCheckPaymentStatus,
                onPressed: context
                    .read<ParentAddChildCubit>()
                    .checkPaymentStatus,
              ),
              const SizedBox(height: 12),
              if (state.checkoutUrl?.isNotEmpty == true)
                CustomAppButton(
                  text: S.of(context).parentOpenPaymentPage,
                  onPressed: context.read<ParentAddChildCubit>().reopenCheckout,
                ),
            ],
            if (state.phase == ParentAddChildPhase.failure)
              CustomAppButton(
                text: state.paymentStatus == null
                    ? S.of(context).retry
                    : S.of(context).parentRetryPayment,
                onPressed: state.paymentStatus == null
                    ? context.read<ParentAddChildCubit>().submit
                    : context.read<ParentAddChildCubit>().retryPayment,
              ),
          ],
        ),
      ),
    );
  }
}
