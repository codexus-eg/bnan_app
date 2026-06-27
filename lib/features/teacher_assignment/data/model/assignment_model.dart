import 'package:bnan_app/generated/l10n.dart';

class AssignmentModel {
  final String id;
  final String classroomSubject;
  final String teacher;
  final AssignmentSubjectModel? subject;
  final AssignmentGradeModel? grade;
  final String title;
  final String description;
  final String dueDate;
  final String attachment;
  final int totalPoints;
  final String createdAt;
  final String updatedAt;
  final String status;
  final int submitted;
  final int totalStudents;

  const AssignmentModel({
    required this.id,
    required this.classroomSubject,
    required this.teacher,
    required this.subject,
    required this.grade,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.attachment,
    required this.totalPoints,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.submitted,
    required this.totalStudents,
  });

  factory AssignmentModel.fromJson(Map<String, dynamic> json) {
    return AssignmentModel(
      id: json['id'] ?? '',
      classroomSubject: _classroomSubjectId(json['classroomSubject']),
      teacher: json['teacher'] ?? '',
      subject: json['subject'] is Map<String, dynamic>
          ? AssignmentSubjectModel.fromJson(json['subject'])
          : null,
      grade: json['grade'] is Map<String, dynamic>
          ? AssignmentGradeModel.fromJson(json['grade'])
          : null,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      dueDate: json['dueDate'] ?? '',
      attachment: json['attachment'] ?? '',
      totalPoints: json['totalPoints'] ?? 0,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      status: json['status'] ?? '',
      submitted: json['submitted'] ?? 0,
      totalStudents: json['totalStudents'] ?? 0,
    );
  }

  factory AssignmentModel.placeholder() {
    return const AssignmentModel(
      id: '',
      classroomSubject: '',
      teacher: '',
      subject: AssignmentSubjectModel(name: 'Math', id: ''),
      grade: AssignmentGradeModel(id: '', name: 'Grade 7'),
      title: 'تمارين الجمع والطرح',
      description: 'حل التمارين من صفحة 45 إلى 48',
      dueDate: '2026-06-30T23:59:59.000Z',
      attachment: '',
      totalPoints: 20,
      createdAt: '',
      updatedAt: '',
      status: 'active',
      submitted: 0,
      totalStudents: 2,
    );
  }

  static List<AssignmentModel> placeholderList() {
    return List.generate(5, (_) => AssignmentModel.placeholder());
  }

  static String _classroomSubjectId(dynamic value) {
    if (value is String) return value;

    if (value is Map<String, dynamic>) {
      return value['id'] ?? '';
    }

    return '';
  }

  bool get isActive => status == 'active';

  bool get isCompleted => status == 'completed';

  String get statusText => isActive ? S.current.active : S.current.finished;

  String get subjectName => subject?.name ?? '';
  String get formattedDueDate {
    if (dueDate.isEmpty) return '';

    return DateTime.parse(dueDate).toLocal().toString().split(' ').first;
  }

  String get gradeName => grade?.name ?? '';

  String get submissionsText => '$totalStudents / $submitted';
}

class AssignmentSubjectModel {
  final String name;
  final String id;

  const AssignmentSubjectModel({required this.name, required this.id});

  factory AssignmentSubjectModel.fromJson(Map<String, dynamic> json) {
    return AssignmentSubjectModel(
      name: json['name'] ?? '',
      id: json['id'] ?? '',
    );
  }
}

class AssignmentGradeModel {
  final String id;
  final String name;

  const AssignmentGradeModel({required this.id, required this.name});

  factory AssignmentGradeModel.fromJson(Map<String, dynamic> json) {
    return AssignmentGradeModel(id: json['id'] ?? '', name: json['name'] ?? '');
  }
}
