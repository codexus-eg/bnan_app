import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/features/admin/presentation/manager/admin_dashboard_cubit.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminDashboardFailureView extends StatelessWidget {
  const AdminDashboardFailureView({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsetsDirectional.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            NoDataWidget(title: message),
            const SizedBox(height: 12),
            CustomAppButton(
              text: S.of(context).retry,
              onPressed: context.read<AdminDashboardCubit>().load,
            ),
          ],
        ),
      ),
    );
  }
}
