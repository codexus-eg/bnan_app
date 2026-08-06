class ClassroomSummaryModel {
  const ClassroomSummaryModel({
    required this.title,
    required this.content,
    required this.docUrl,
    required this.nextSteps,
  });

  final String? title;
  final String? content;
  final String? docUrl;
  final List<String> nextSteps;

  factory ClassroomSummaryModel.fromJson(Map<String, dynamic> json) {
    String? text(String key) {
      final value = json[key]?.toString().trim();
      return value?.isNotEmpty == true ? value : null;
    }

    final steps = json['nextSteps'];
    return ClassroomSummaryModel(
      title: text('title'),
      content: text('content'),
      docUrl: text('docUrl'),
      nextSteps: steps is List
          ? steps
                .whereType<String>()
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty)
                .toList()
          : const [],
    );
  }
}
