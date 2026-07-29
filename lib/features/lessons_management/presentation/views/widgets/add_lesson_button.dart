import 'package:bnan_app/core/shared_widget/add_new_topic_button.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class AddLessonButton extends StatelessWidget {
  const AddLessonButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AddNewTopicButton(
      title: S.of(context).addLesson,
      path: ImageManager.plus,
      onTap: onTap,
      padding: const EdgeInsetsDirectional.symmetric(
        vertical: 6,
        horizontal: 30,
      ),
    );
  }
}
