import 'package:bnan_app/core/shared_widget/empty_state.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class NoDataWidget extends StatelessWidget {
  const NoDataWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      image: ImageManager.noData,
      title: S.of(context).noDataAvailable,
    );
  }
}