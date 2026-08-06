import 'package:bnan_app/features/chats/data/models/classroom_recording_model.dart';

class ClassroomRecordingsResponse {
  const ClassroomRecordingsResponse(this.items);

  final List<ClassroomRecordingModel> items;

  factory ClassroomRecordingsResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    if (data is! List) return const ClassroomRecordingsResponse([]);
    return ClassroomRecordingsResponse(
      data
          .whereType<Map>()
          .map(
            (item) => ClassroomRecordingModel.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList(growable: false),
    );
  }
}
