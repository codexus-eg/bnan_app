import 'package:bnan_app/features/dashboard/data/models/dashboard_data.dart';
import 'package:bnan_app/features/dashboard/data/models/dashboard_parsing.dart';
import 'package:bnan_app/features/parent_home/data/models/parent_child_model.dart';

class ParentDashboardModel extends DashboardData {
  const ParentDashboardModel({
    required super.generatedAt,
    required this.childrenCount,
    required this.certificates,
    required this.evaluations,
    required this.subscriptions,
    required this.children,
  }) : super(role: DashboardRole.parent);

  final int childrenCount, certificates, evaluations, subscriptions;
  final List<ParentChildModel> children;

  factory ParentDashboardModel.fromJson(
    Map<String, dynamic> json,
    DateTime? at,
  ) {
    final counts = dashboardMap(json['counts']);
    return ParentDashboardModel(
      generatedAt: at,
      childrenCount: dashboardInt(counts['children']),
      certificates: dashboardInt(counts['certificates']),
      evaluations: dashboardInt(counts['evaluations']),
      subscriptions: dashboardInt(counts['subscriptions']),
      children: dashboardList(
        json['children'],
      ).map(ParentChildModel.fromJson).toList(),
    );
  }
}
