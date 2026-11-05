class TeacherSessionStatisticsModel {
  const TeacherSessionStatisticsModel({
    this.totalSessions = 0,
    this.totalHours = 0,
  });

  final num totalSessions;
  final num totalHours;

  factory TeacherSessionStatisticsModel.fromResponse(dynamic response) {
    if (response is! Map<String, dynamic>) {
      return const TeacherSessionStatisticsModel();
    }
    final data = response['data'];
    if (data is Map<String, dynamic>) {
      return TeacherSessionStatisticsModel.fromJson(data);
    }
    return TeacherSessionStatisticsModel.fromJson(response);
  }

  factory TeacherSessionStatisticsModel.fromJson(Map<String, dynamic> json) {
    num parse(List<String> keys) {
      for (final key in keys) {
        final val = json[key];
        if (val is num) return val;
        if (val is String) {
          final parsed = num.tryParse(val.replaceAll(',', '.'));
          if (parsed != null) return parsed;
        }
      }
      return 0;
    }

    return TeacherSessionStatisticsModel(
      totalSessions: parse([
        'totalSessions',
        'sessionsCount',
        'sessions',
        'sessionCount',
        'completedSessions',
        'count',
        'total',
      ]),
      totalHours: parse([
        'totalHours',
        'hoursCount',
        'hours',
        'totalDurationHours',
        'totalDuration',
        'durationHours',
        'duration',
      ]),
    );
  }
}
