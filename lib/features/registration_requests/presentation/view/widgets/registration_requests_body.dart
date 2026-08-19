import 'package:bnan_app/core/shared_widget/filter_chip/custom_filter_tabs.dart';
import 'package:bnan_app/features/admin_subject_requests/presentation/manager/admin_subject_requests_cubit.dart';
import 'package:bnan_app/features/admin_subject_requests/presentation/widgets/admin_subject_requests_section.dart';
import 'package:bnan_app/features/classroom_change_requests/presentation/manager/admin_change_requests_cubit.dart';
import 'package:bnan_app/features/classroom_change_requests/presentation/widgets/admin_change_requests_section.dart';
import 'package:bnan_app/features/registration_requests/presentation/view/widgets/registration_requests_section.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum AdminRequestsSection { registration, subject, cancellation }

class RegistrationRequestsBody extends StatefulWidget {
  const RegistrationRequestsBody({super.key});
  @override
  State<RegistrationRequestsBody> createState() =>
      _RegistrationRequestsBodyState();
}

class _RegistrationRequestsBodyState extends State<RegistrationRequestsBody> {
  var _section = AdminRequestsSection.registration;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
        child: CustomFilterTabs<AdminRequestsSection>(
          items: {
            AdminRequestsSection.registration: S
                .of(context)
                .adminRegistrationRequestsSection,
            AdminRequestsSection.subject: S
                .of(context)
                .adminSubjectRequestsSection,
            AdminRequestsSection.cancellation: S
                .of(context)
                .cancellationRequests,
          },
          selectedItem: _section,
          onChanged: _changeSection,
        ),
      ),
      Expanded(
        child: IndexedStack(
          index: _section.index,
          children: const [
            RegistrationRequestsSection(),
            AdminSubjectRequestsSection(),
            AdminChangeRequestsSection(),
          ],
        ),
      ),
    ],
  );

  void _changeSection(AdminRequestsSection section) {
    if (section == _section) return;
    if (section == AdminRequestsSection.subject) {
      final cubit = context.read<AdminSubjectRequestsCubit>();
      if (!cubit.hasLoaded) cubit.load();
    }
    if (section == AdminRequestsSection.cancellation) {
      final cubit = context.read<AdminChangeRequestsCubit>();
      if (!cubit.hasLoaded) cubit.load();
    }
    setState(() => _section = section);
  }
}
