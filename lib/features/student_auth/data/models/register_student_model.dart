class RegisterStudentModel {
  const RegisterStudentModel({
    required this.fullName,
    required this.email,
    required this.password,
    required this.grade,
    required this.subjects,
    this.subjectNotes,
  });

  final String fullName;
  final String email;
  final String password;
  final String grade;
  final List<String> subjects;
  final Map<String, String>? subjectNotes;

  Map<String, dynamic> toJson() {
    final notes = _cleanNotes(subjectNotes, subjects);
    return {
      'fullName': fullName,
      'email': email,
      'password': password,
      'grade': grade,
      'subjects': subjects,
      if (notes != null && notes.isNotEmpty) 'subjectNotes': notes,
    };
  }

  static Map<String, String>? _cleanNotes(
    Map<String, String>? notes,
    List<String> subjects,
  ) {
    if (notes == null || notes.isEmpty) return null;
    final validIds = subjects.toSet();
    final cleaned = <String, String>{};
    for (final entry in notes.entries) {
      final key = entry.key.trim();
      final value = entry.value.trim();
      if (validIds.contains(key) && value.isNotEmpty) {
        cleaned[key] = value;
      }
    }
    return cleaned.isEmpty ? null : cleaned;
  }
}