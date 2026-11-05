class UpsertEvaluationRequestModel {
  const UpsertEvaluationRequestModel({
    required this.student,
    required this.classroom,
    required this.subject,
    required this.week,
    this.attendance,
    required this.participation,
    this.homework,
    required this.behavior,
    this.bonus = 0,
    this.notes = '',
  });

  final String student, classroom, subject;
  final int week;
  final int bonus;
  final String? attendance, homework;
  final String participation, behavior, notes;

  Map<String, dynamic> toJson() => {
    'student': student,
    'classroom': classroom,
    'subject': subject,
    'week': week,
    'participation': participation,
    'behavior': behavior,
    'bonus': bonus,
    'notes': notes,
  };
}
