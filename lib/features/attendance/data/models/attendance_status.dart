enum AttendanceStatus { present, absent, late }

extension AttendanceStatusApi on AttendanceStatus {
  String get apiValue => name;

  static AttendanceStatus fromApi(Object? value) {
    return AttendanceStatus.values.firstWhere(
      (status) => status.name == value?.toString().trim().toLowerCase(),
      orElse: () => AttendanceStatus.present,
    );
  }
}
