import 'package:bnan_app/core/helper/attachment_file.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/data/models/student_assignment_model.dart';
import 'package:bnan_app/features/teacher_assignment/data/model/student_assignment_submission.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() => S.load(const Locale('ar')));

  test('parses a relative string attachment and keeps its extension', () {
    final file = AttachmentFile.fromJson('/uploads/homework_math.pdf');
    expect(file.source, '/uploads/homework_math.pdf');
    expect(file.name, 'homework_math.pdf');
  });

  test('student assignment keeps backend attachment name from object', () {
    final assignment = AssignmentModel.fromJson({
      'id': 'a1',
      'attachment': {
        'path': '/uploads/1786809455617',
        'originalName': 'homework_math.docx',
      },
    });
    expect(assignment.attachment, '/uploads/1786809455617');
    expect(assignment.attachmentName, 'homework_math.docx');
  });

  test('student assignment displays the grade returned by the API', () {
    final assignment = AssignmentModel.fromJson({
      'grade': 85,
      'totalPoints': 100,
      'submitted': true,
    });

    expect(assignment.grade, 85);
    expect(assignment.badgeText, '85 / 100');
  });

  test('teacher submission parses encoded attachment filename', () {
    final submission = AssignmentSubmissionDetailsModel.fromJson({
      'id': 's1',
      'attachment': '/uploads/math%20answer.xlsx',
    });
    expect(submission.attachment, '/uploads/math%20answer.xlsx');
    expect(submission.attachmentName, 'math answer.xlsx');
  });
}
