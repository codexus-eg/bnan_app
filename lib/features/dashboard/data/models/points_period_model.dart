class PointsPeriodModel {
  const PointsPeriodModel({
    this.weekStart,
    this.weekEnd,
    this.cutoff,
    this.timezone = '',
  });

  final DateTime? weekStart;
  final DateTime? weekEnd;
  final DateTime? cutoff;
  final String timezone;

  factory PointsPeriodModel.fromJson(Map<String, dynamic> json) =>
      PointsPeriodModel(
        weekStart: DateTime.tryParse(json['weekStart']?.toString() ?? ''),
        weekEnd: DateTime.tryParse(json['weekEnd']?.toString() ?? ''),
        cutoff: DateTime.tryParse(json['cutoff']?.toString() ?? ''),
        timezone: json['timezone']?.toString() ?? '',
      );
}
