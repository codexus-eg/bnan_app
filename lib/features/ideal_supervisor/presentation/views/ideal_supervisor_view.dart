import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/ideal_supervisor/presentation/views/widgets/ideal_supervisor_body.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class IdealSupervisorView extends StatelessWidget {
  const IdealSupervisorView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: CustomAppbar(
      headerText: S.of(context).idealSupervisor,
      iconNeeded: true,
    ),
    body: const IdealSupervisorBody(),
  );
}
