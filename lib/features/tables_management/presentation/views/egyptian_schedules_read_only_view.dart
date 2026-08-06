import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/tables_management/presentation/views/widgets/egyptian_schedules_read_only_body.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class EgyptianSchedulesReadOnlyView extends StatelessWidget {
  const EgyptianSchedulesReadOnlyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(headerText: S.of(context).schedule),
      body: const EgyptianSchedulesReadOnlyBody(),
    );
  }
}
