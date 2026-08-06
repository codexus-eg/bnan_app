import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/empty_state.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class TableSchedulesFailure extends StatelessWidget {
  const TableSchedulesFailure({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 230,
            child: EmptyStateWidget(image: ImageManager.noData, title: message),
          ),
          SizedBox(
            width: 180,
            child: CustomAppButton(
              key: const Key('egyptianSchedulesRetry'),
              text: S.of(context).retry,
              onPressed: onRetry,
            ),
          ),
        ],
      ),
    );
  }
}
