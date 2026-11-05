import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/tables_management/presentation/views/widgets/tables_management_body.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class TablesManagementView extends StatelessWidget {
  const TablesManagementView({
    super.key,
    this.showBackButton = true,
    this.useSupervisorClassrooms = false,
    this.initialClassId,
  });

  final bool? showBackButton;
  final bool? useSupervisorClassrooms;
  final String? initialClassId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        headerText: S.of(context).lessonsManagement,
        iconNeeded: showBackButton ?? true,
      ),
      body: TablesManagementBody(
        useSupervisorClassrooms: useSupervisorClassrooms ?? false,
        initialClassId: initialClassId,
      ),
    );
  }
}
