import 'package:bnan_app/features/teacher_chats/data/models/teacher_chat_model.dart';
import 'package:bnan_app/features/teacher_chats/presentation/views/widgets/teacher_chat_card.dart';
import 'package:flutter/material.dart';

class TeacherChatsBody extends StatelessWidget {
  const TeacherChatsBody({super.key});

  static const chats = [
    TeacherChatModel(name: 'أحمد محمد', grade: 'الثاني الإعدادي'),
    TeacherChatModel(name: 'ليلي أحمد', grade: ' الأول الإعدادي'),
    TeacherChatModel(name: 'نور سعيد', grade: 'الثالث الإعدادي'),
    TeacherChatModel(name: 'محمد علي', grade: 'الثاني الإعدادي'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsetsDirectional.all(16),
      itemCount: chats.length,
      itemBuilder: (context, index) {
        return TeacherChatCard(chatModel: chats[index]);
      },
    );
  }
}
