import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class PayrollFailureView extends StatelessWidget {
  const PayrollFailureView({
    super.key,
    required this.message,
    required this.onRetry,
  });
  final String message;
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NoDataWidget(title: message),
          const SizedBox(height: 16),
          CustomAppButton(text: S.of(context).retry, onPressed: onRetry),
        ],
      ),
    ),
  );
}
