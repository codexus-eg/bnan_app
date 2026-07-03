import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class TeacherApplicationDetailsHeader extends StatelessWidget {
  const TeacherApplicationDetailsHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(title, style: StylesManager.styleBold18(context))),
        InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.close, size: 22),
        ),
      ],
    );
  }
}
