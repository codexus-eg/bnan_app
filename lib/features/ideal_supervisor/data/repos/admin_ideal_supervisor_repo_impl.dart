import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/network/repo_guard.dart';
import 'package:bnan_app/features/ideal_supervisor/data/models/ideal_supervisor_request.dart';
import 'package:bnan_app/features/ideal_supervisor/data/repos/admin_ideal_supervisor_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

class AdminIdealSupervisorRepoImpl implements AdminIdealSupervisorRepo {
  const AdminIdealSupervisorRepoImpl(this.api);
  final ApiConsumer api;

  @override
  issueIdealSupervisors(IdealSupervisorRequest request) => repoGuard(() async {
    final body = request.toJson();
    if (kDebugMode) {
      debugPrint('endpoint: ${EndPoints.adminIdealSupervisors}');
      debugPrint('selected supervisor count: ${request.supervisorIds.length}');
      debugPrint('selected supervisor IDs: ${request.supervisorIds}');
      debugPrint('body keys: ${body.keys.toList()}');
    }
    await api.post(
      EndPoints.adminIdealSupervisors,
      data: body,
      isProtected: true,
    );
    return unit;
  });
}
