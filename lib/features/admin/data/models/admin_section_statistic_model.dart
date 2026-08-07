import 'package:bnan_app/features/admin/data/models/admin_dashboard_parsing.dart';

class AdminSectionStatisticModel {
  const AdminSectionStatisticModel({
    required this.key,
    required this.count,
    required this.percentage,
  });

  final String key;
  final int count;
  final double percentage;

  double get progress => (percentage / 100).clamp(0.0, 1.0);

  factory AdminSectionStatisticModel.fromJson(Map<String, dynamic> json) {
    return AdminSectionStatisticModel(
      key: adminString(json['key']),
      count: adminInt(json['count']),
      percentage: adminDouble(json['percentage']),
    );
  }
}
