import 'package:bnan_app/features/parent_children/presentation/manager/parent_add_child_cubit/parent_add_child_cubit.dart';
import 'package:bnan_app/features/parent_children/presentation/widgets/parent_egyptian_payment_fields.dart';
import 'package:bnan_app/features/parent_children/presentation/widgets/parent_gulf_payment_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParentPaymentStep extends StatelessWidget {
  const ParentPaymentStep({super.key});
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ParentAddChildCubit>();
    final state = context.watch<ParentAddChildCubit>().state;
    return state.isGulf
        ? const ParentGulfPaymentFields()
        : ParentEgyptianPaymentFields(
            receipt: state.receipt,
            onReceiptChanged: (v) => cubit.updateEgyptianPayment(receipt: v),
            onMethodChanged: (v) => cubit.updateEgyptianPayment(method: v),
            onReferenceChanged: (v) =>
                cubit.updateEgyptianPayment(referenceNumber: v),
          );
  }
}
