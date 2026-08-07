import 'package:bnan_app/features/student_subjects/data/models/student_subject_model.dart';

List<StudentSubjectModel> filterStudentSubjects(
  List<StudentSubjectModel> subjects,
  String query,
) {
  final normalized = query.trim().toLowerCase();
  if (normalized.isEmpty) return subjects;
  return subjects
      .where((subject) => subject.name.toLowerCase().contains(normalized))
      .toList(growable: false);
}
