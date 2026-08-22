import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_delete_dialog.dart';
import 'package:bnan_app/features/discount_codes/presentation/manager/discount_code_actions_cubit.dart';
import 'package:bnan_app/features/discount_codes/presentation/manager/discount_code_actions_state.dart';
import 'package:bnan_app/features/discount_codes/presentation/manager/discount_codes_cubit.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> showDeleteDiscountCodeDialog(BuildContext context, String id) {
  return showDialog(
    context: context,
    builder: (_) => MultiBlocProvider(
      providers: [
        BlocProvider.value(value: context.read<DiscountCodeActionsCubit>()),
        BlocProvider.value(value: context.read<DiscountCodesCubit>()),
      ],
      child: _DeleteDiscountCodeDialog(id: id),
    ),
  );
}

class _DeleteDiscountCodeDialog extends StatelessWidget {
  const _DeleteDiscountCodeDialog({required this.id});
  final String id;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DiscountCodeActionsCubit, DiscountCodeActionsState>(
      listener: (context, state) {
        if (state is DiscountCodeActionFailure) {
          showCustomSnackBar(context, state.message, false);
        }
        if (state is DiscountCodeDeleted) {
          context.read<DiscountCodesCubit>().remove(state.id);
          showCustomSnackBar(context, S.of(context).discountCodeDeleted, true);
          Navigator.pop(context);
        }
      },
      builder: (context, state) => CustomAppDialog(
        child: CustomDeleteDialog(
          gradeId: id,
          isLoading: state is DiscountCodeActionLoading,
          showCancelButton: true,
          dialogHeader: S.of(context).deleteDiscountCode,
          subtitle: S.of(context).deleteDiscountCodeConfirmation,
          onPressed: state is DiscountCodeActionLoading
              ? null
              : () => context.read<DiscountCodeActionsCubit>().delete(id),
        ),
      ),
    );
  }
}
