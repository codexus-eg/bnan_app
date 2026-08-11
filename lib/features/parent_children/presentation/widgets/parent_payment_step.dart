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
        ? ParentGulfPaymentFields(
            onCityChanged: (v) => cubit.updateAddress(city: v),
            onRegionChanged: (v) => cubit.updateAddress(region: v),
            onLine1Changed: (v) => cubit.updateAddress(line1: v),
            onLine2Changed: (v) => cubit.updateAddress(line2: v),
          )
        : ParentEgyptianPaymentFields(
            receipt: state.receipt,
            onReceiptChanged: (v) => cubit.updateEgyptianPayment(receipt: v),
            onMethodChanged: (v) => cubit.updateEgyptianPayment(method: v),
            onReferenceChanged: (v) =>
                cubit.updateEgyptianPayment(referenceNumber: v),
          );
  }
}
