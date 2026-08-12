import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class DashboardFailureView extends StatelessWidget {
  const DashboardFailureView({
    super.key,
    required this.message,
    required this.onRetry,
  });
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsetsDirectional.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NoDataWidget(title: message),
          const SizedBox(height: 12),
          SizedBox(
            width: 150,
            child: CustomAppButton(
              text: S.of(context).retry,
              onPressed: onRetry,
            ),
          ),
        ],
      ),
    ),
  );
}
