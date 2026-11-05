import 'excluded_session_item.dart';
import 'payroll_parsing.dart';

class PayrollListItemModel {
  const PayrollListItemModel({
    required this.teacherId,
    required this.fullName,
    required this.email,
    required this.status,
    required this.payrollId,
    this.generalDuration = '0h',
    this.courseDuration = '0h',
    this.totalDuration = '0h',
    this.excludedSessionsCount = 0,
    this.excludedSessionsList = const [],
    this.overlappingStatementId,
    this.overlappingStatementStatus,
    this.curriculumId = '',
    String? gulfDuration,
    int? egyptianSessions,
    int? curriculumsCount,
    int? excludedSessions,
  })  : gulfDuration = gulfDuration ?? generalDuration,
        egyptianSessions = egyptianSessions ?? 0,
        curriculumsCount = curriculumsCount ?? 1,
        excludedSessions = excludedSessions ?? excludedSessionsCount;

  final String teacherId;
  final String fullName;
  final String email;
  final String status;
  final String payrollId;
  final String generalDuration;
  final String courseDuration;
  final String totalDuration;
  final int excludedSessionsCount;
  final List<ExcludedSessionItem> excludedSessionsList;
  final String? overlappingStatementId;
  final String? overlappingStatementStatus;
  final String curriculumId;

  final String gulfDuration;
  final int egyptianSessions;
  final int curriculumsCount;
  final int excludedSessions;

  bool get hasOverlap =>
      overlappingStatementId != null && overlappingStatementId!.isNotEmpty;

  PayrollListItemModel copyWith({
    String? overlappingStatementId,
    String? overlappingStatementStatus,
    String? curriculumId,
  }) {
    return PayrollListItemModel(
      teacherId: teacherId,
      fullName: fullName,
      email: email,
      status: status,
      payrollId: payrollId,
      generalDuration: generalDuration,
      courseDuration: courseDuration,
      totalDuration: totalDuration,
      excludedSessionsCount: excludedSessionsCount,
      excludedSessionsList: excludedSessionsList,
      overlappingStatementId:
          overlappingStatementId ?? this.overlappingStatementId,
      overlappingStatementStatus:
          overlappingStatementStatus ?? this.overlappingStatementStatus,
      curriculumId: curriculumId ?? this.curriculumId,
      gulfDuration: gulfDuration,
      egyptianSessions: egyptianSessions,
      curriculumsCount: curriculumsCount,
      excludedSessions: excludedSessions,
    );
  }

  factory PayrollListItemModel.fromJson(Object? value) {
    final json = payrollMap(value);
    final general = payrollMap(json['general']);
    final courses = payrollList(json['courses']);
    final payrollObj =
        json['payroll'] is Map ? payrollMap(json['payroll']) : null;
    final gulf = payrollMap(json['gulf']);
    final egyptian = payrollMap(json['egyptian']);

    final genMinutes = payrollInt(general['minutes']);
    int courseMinutes = 0;
    for (final c in courses) {
      if (c is Map) courseMinutes += payrollInt(c['minutes']);
    }

    final genDurationStr = payrollString(general['displayDuration']);
    final generalDuration = genDurationStr.isNotEmpty
        ? genDurationStr
        : (genMinutes > 0
            ? _formatMinutes(genMinutes)
            : payrollString(gulf['displayDuration']));

    final courseDuration =
        courseMinutes > 0 ? _formatMinutes(courseMinutes) : '0h';
    final totalMinutes = genMinutes + courseMinutes;
    final totalDuration = totalMinutes > 0
        ? _formatMinutes(totalMinutes)
        : (generalDuration.isNotEmpty ? generalDuration : '0h');

    final excludedList = payrollList(json['excludedSessions'])
        .map(ExcludedSessionItem.fromJson)
        .toList();

    return PayrollListItemModel(
      teacherId: payrollString(json['teacherId'] ?? json['_id'] ?? json['id']),
      fullName: payrollString(json['fullName'] ?? json['name']),
      email: payrollString(json['email']),
      status: payrollString(
        payrollObj?['status'] ??
            json['payrollStatus'] ??
            json['status'] ??
            'unprepared',
      ),
      payrollId: payrollString(
        payrollObj?['_id'] ?? payrollObj?['id'] ?? json['payrollId'],
      ),
      generalDuration: generalDuration.isNotEmpty ? generalDuration : '0h',
      courseDuration: courseDuration,
      totalDuration: totalDuration,
      excludedSessionsCount: payrollInt(json['excludedSessionsCount']),
      excludedSessionsList: excludedList,
      gulfDuration: generalDuration.isNotEmpty ? generalDuration : '0h',
      egyptianSessions: payrollInt(egyptian['sessionsCount']),
      curriculumsCount: payrollInt(json['curriculumsCount'] ?? 1),
      excludedSessions: payrollInt(json['excludedSessionsCount']),
    );
  }

  static String _formatMinutes(int minutes) {
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    if (remainingMinutes == 0) return '${hours}h';
    return '${hours}h ${remainingMinutes}m';
  }
}
