import 'package:bnan_app/features/admin/data/models/admin_dashboard_parsing.dart';
import 'package:bnan_app/features/admin/data/models/admin_section_statistic_model.dart';

class AdminStudentsBySectionModel {
  const AdminStudentsBySectionModel({this.total = 0, this.sections = const []});

  final int total;
  final List<AdminSectionStatisticModel> sections;

  factory AdminStudentsBySectionModel.fromJson(Object? value) {
    final json = adminMap(value);
    final rawSections = json['sections'];
    return AdminStudentsBySectionModel(
      total: adminInt(json['total']),
      sections: rawSections is List
          ? rawSections
                .whereType<Map>()
                .map(
                  (item) => AdminSectionStatisticModel.fromJson(
                    Map<String, dynamic>.from(item),
                  ),
                )
                .toList()
          : const [],
    );
  }
}
