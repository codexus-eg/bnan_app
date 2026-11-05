import 'dart:io';

class CreateAssignmentRequestModel {
  final String title;
  final String description;
  final String dueDate;
  final String classroom;
  final String subject;
  final num totalPoints;
  final File? attachment;

  const CreateAssignmentRequestModel({
    required this.title,
    required this.description,
    required this.dueDate,
    required this.classroom,
    required this.subject,
    required this.totalPoints,
    this.attachment,
  });

  Map<String, dynamic> toJson() {
    return {
      'classroom': classroom,
      'subject': subject,
      'title': title,
      if (description.isNotEmpty) 'description': description,
      'dueDate': dueDate,
      'totalPoints': totalPoints,
      if (attachment != null) 'attachment': attachment,
    };
  }
}