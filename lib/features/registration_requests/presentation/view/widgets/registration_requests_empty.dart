import 'package:bnan_app/core/shared_widget/empty_state.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:flutter/material.dart';

class RegistrationRequestsEmpty extends StatelessWidget {
  const RegistrationRequestsEmpty({
    super.key,
    required this.message,
    required this.onRefresh,
  });

  final String message;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return RefreshIndicator(
          onRefresh: onRefresh,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(
                height: constraints.maxHeight,
                child: EmptyStateWidget(
                  image: ImageManager.noData,
                  title: message,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
