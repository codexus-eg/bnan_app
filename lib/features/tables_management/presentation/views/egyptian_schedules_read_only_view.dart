import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/tables_management/presentation/views/widgets/egyptian_schedules_read_only_body.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class EgyptianSchedulesReadOnlyView extends StatelessWidget {
  const EgyptianSchedulesReadOnlyView({super.key, this.showBackButton = true});

  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        headerText: S.of(context).schedule,
        iconNeeded: showBackButton,
      ),
      body: const EgyptianSchedulesReadOnlyBody(),
    );
  }
}
