class UpsertEvaluationRequestModel {
  const UpsertEvaluationRequestModel({
    required this.student,
    required this.classroom,
    required this.subject,
    required this.week,
    required this.attendance,
    required this.participation,
    required this.homework,
    required this.behavior,
    this.notes = '',
  });

  final String student, classroom, subject;
  final int week;
  final String attendance, participation, homework, behavior, notes;

  Map<String, dynamic> toJson() => {
    'student': student,
    'classroom': classroom,
    'subject': subject,
    'week': week,
    'attendance': attendance,
    'participation': participation,
    'homework': homework,
    'behavior': behavior,
    'notes': notes,
  };
}
