import 'package:bnan_app/features/chats/data/models/classroom_summary_model.dart';

class ClassroomSummaryItemModel {
  const ClassroomSummaryItemModel({
    required this.sessionName,
    required this.summary,
  });

  final String sessionName;
  final ClassroomSummaryModel? summary;

  factory ClassroomSummaryItemModel.fromJson(Map<String, dynamic> json) {
    final rawSummary = json['summary'];
    return ClassroomSummaryItemModel(
      sessionName: json['sessionName']?.toString().trim() ?? '',
      summary: rawSummary is Map
          ? ClassroomSummaryModel.fromJson(
              Map<String, dynamic>.from(rawSummary),
            )
          : null,
    );
  }
}
