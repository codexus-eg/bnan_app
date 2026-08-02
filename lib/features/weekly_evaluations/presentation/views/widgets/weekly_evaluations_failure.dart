import 'package:bnan_app/core/shared_widget/empty_state.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:flutter/material.dart';

class WeeklyEvaluationsFailure extends StatelessWidget {
  const WeeklyEvaluationsFailure({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(image: ImageManager.noData, title: message);
  }
}
