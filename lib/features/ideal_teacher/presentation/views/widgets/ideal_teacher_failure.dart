import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/empty_state.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class IdealTeacherFailure extends StatelessWidget {
  const IdealTeacherFailure({super.key, required this.message, this.onRetry});
  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        EmptyStateWidget(image: ImageManager.noData, title: message),
        if (onRetry != null)
          SizedBox(
            width: 180,
            child: CustomAppButton(
              text: S.of(context).retry,
              onPressed: onRetry,
            ),
          ),
      ],
    ),
  );
}
