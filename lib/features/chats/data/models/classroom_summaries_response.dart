import 'package:bnan_app/features/chats/data/models/classroom_summary_item_model.dart';

class ClassroomSummariesResponse {
  const ClassroomSummariesResponse(this.items);

  final List<ClassroomSummaryItemModel> items;

  factory ClassroomSummariesResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    if (data is! List) return const ClassroomSummariesResponse([]);
    return ClassroomSummariesResponse(
      data
          .whereType<Map>()
          .map(
            (item) => ClassroomSummaryItemModel.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList(growable: false),
    );
  }
}
