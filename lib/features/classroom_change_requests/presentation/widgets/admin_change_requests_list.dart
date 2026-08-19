import 'package:bnan_app/features/classroom_change_requests/data/models/classroom_change_request_model.dart';
import 'package:bnan_app/features/classroom_change_requests/presentation/widgets/admin_change_request_card.dart';
import 'package:flutter/material.dart';

class AdminChangeRequestsList extends StatelessWidget {
  const AdminChangeRequestsList({
    super.key,
    required this.requests,
    required this.onRefresh,
  });
  final List<ClassroomChangeRequestModel> requests;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) => RefreshIndicator(
    onRefresh: onRefresh,
    child: ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 24),
      itemCount: requests.length,
      separatorBuilder: (_, _) => const SizedBox(height: 16),
      itemBuilder: (_, index) =>
          AdminChangeRequestCard(request: requests[index]),
    ),
  );
}
