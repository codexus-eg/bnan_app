class ClassroomRecordingModel {
  const ClassroomRecordingModel({
    required this.sessionName,
    required this.recordingLink,
    this.localUrl,
  });

  final String sessionName;
  final String? recordingLink;
  final String? localUrl;
  String? get playbackUrl => localUrl ?? recordingLink;

  factory ClassroomRecordingModel.fromJson(Map<String, dynamic> json) {
    final link = json['recordingLink']?.toString().trim();
    final recording = json['recording'];
    final local = recording is Map
        ? recording['localUrl']?.toString().trim()
        : null;
    return ClassroomRecordingModel(
      sessionName: json['sessionName']?.toString().trim() ?? '',
      recordingLink: link?.isNotEmpty == true ? link : null,
      localUrl: local?.isNotEmpty == true ? local : null,
    );
  }
}
