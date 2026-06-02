import 'package:bnan_app/features/student_groups/presentation/presentation/views/widgets/request_lesson/request_lesson_body.dart';
import 'package:flutter/material.dart';

class RequestLessonView extends StatelessWidget {
  const RequestLessonView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: RequestLessonBody(),
    );
  }
}