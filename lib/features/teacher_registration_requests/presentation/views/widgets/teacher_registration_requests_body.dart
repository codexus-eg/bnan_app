import 'package:bnan_app/features/teacher_registration_requests/data/models/registration_request_model.dart';
import 'package:bnan_app/features/teacher_registration_requests/presentation/views/widgets/registration_request_card.dart';
import 'package:flutter/material.dart';

class TeacherRegistrationRequestsBody extends StatelessWidget {
  const TeacherRegistrationRequestsBody({super.key});

  static const requests = [
    RegistrationRequestModel(
      studentName: 'أحمد محمد',
      daysAgo: 1,
      subjectName: 'العلوم',
      gradeName: 'الصف الخامس الابتدائي',
      curriculumName: 'المنهج السعودي',
      teacherName: 'البناء الضوئي',
    ),
    RegistrationRequestModel(
      studentName: 'أحمد محمد',
      daysAgo: 1,
      subjectName: 'الرياضيات',
      gradeName: 'الصف الثالث الابتدائي',
      curriculumName: 'المنهج المصري',
      teacherName: 'أريد معلمة مصرية',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsetsDirectional.all(16),
      itemCount: requests.length,
      itemBuilder: (context, index) {
        return RegistrationRequestCard(request: requests[index]);
      },
    );
  }
}