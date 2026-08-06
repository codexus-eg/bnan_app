class ClassroomRecordingModel {
  const ClassroomRecordingModel({
    required this.sessionName,
    required this.recordingLink,
  });

  final String sessionName;
  final String? recordingLink;

  factory ClassroomRecordingModel.fromJson(Map<String, dynamic> json) {
    final link = json['recordingLink']?.toString().trim();
    return ClassroomRecordingModel(
      sessionName: json['sessionName']?.toString().trim() ?? '',
      recordingLink: link?.isNotEmpty == true ? link : null,
    );
  }
}
