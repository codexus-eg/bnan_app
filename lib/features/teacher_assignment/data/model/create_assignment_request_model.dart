import 'dart:io';

class CreateAssignmentRequestModel {
  final String title;
  final String description;
  final String dueDate;
  final String classroom;
  final String subject;
  final File? attachment;

  const CreateAssignmentRequestModel({
    required this.title,
    required this.description,
    required this.dueDate,
    required this.classroom,
    required this.subject,
    this.attachment,
  });

  Map<String, dynamic> toJson() {
    return {
      'classroom': classroom,
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'subject': subject,
      if (attachment != null) 'attachment': attachment,
    };
  }
}