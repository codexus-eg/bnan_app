import 'package:bnan_app/core/shared_widget/filter_chip/custom_filter_tabs.dart';
import 'package:bnan_app/features/admin_subject_requests/data/models/admin_subject_request_status.dart';
import 'package:bnan_app/features/admin_subject_requests/presentation/manager/admin_subject_requests_cubit.dart';
import 'package:bnan_app/features/admin_subject_requests/presentation/widgets/admin_subject_request_status_label.dart';
import 'package:bnan_app/features/admin_subject_requests/presentation/widgets/admin_subject_requests_builder.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminSubjectRequestsSection extends StatefulWidget {
  const AdminSubjectRequestsSection({super.key});
  @override
  State<AdminSubjectRequestsSection> createState() =>
      _AdminSubjectRequestsSectionState();
}

class _AdminSubjectRequestsSectionState
    extends State<AdminSubjectRequestsSection> {
  final _controller = ScrollController();
  @override
  void initState() {
    super.initState();
    _controller.addListener(_loadMore);
  }

  void _loadMore() {
    if (_controller.hasClients &&
        _controller.position.pixels >=
            _controller.position.maxScrollExtent - 200) {
      context.read<AdminSubjectRequestsCubit>().loadMore();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<AdminSubjectRequestsCubit>();
    final s = S.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: CustomFilterTabs<AdminSubjectRequestStatus>(
            items: {
              for (final status in AdminSubjectRequestStatus.values)
                status: adminSubjectRequestStatusLabel(s, status.apiValue),
            },
            selectedItem: cubit.currentStatus,
            onChanged: (status) {
              if (status != cubit.currentStatus) {
                cubit.load(status: status, refresh: true);
              }
            },
          ),
        ),
        Expanded(child: AdminSubjectRequestsBuilder(controller: _controller)),
      ],
    );
  }
}
