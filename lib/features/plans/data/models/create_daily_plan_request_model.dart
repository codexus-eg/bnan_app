class CreateDailyPlanRequestModel {
  const CreateDailyPlanRequestModel({
    required this.day,
    required this.sessionContent,
    required this.sessionAssignment,
  });

  final String day;
  final String sessionContent;
  final String sessionAssignment;

  Map<String, dynamic> toJson() {
    return {
      'type': 'day',
      'day': day,
      'sessionContent': sessionContent,
      'sessionAssignment': sessionAssignment,
    };
  }
}
