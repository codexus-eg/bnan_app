import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:flutter/material.dart';

class RegistrationRequestsEmpty extends StatelessWidget {
  const RegistrationRequestsEmpty({super.key, required this.onRefresh});

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
                child: const NoDataWidget(),
              ),
            ],
          ),
        );
      },
    );
  }
}
