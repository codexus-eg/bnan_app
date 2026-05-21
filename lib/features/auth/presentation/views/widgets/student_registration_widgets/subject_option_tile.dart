import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:flutter/material.dart';

class SubjectOptionTile extends StatelessWidget {
  const SubjectOptionTile({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: ColorManager.greyA8AF.withAlpha(80)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const CircleAvatar(radius: 7, backgroundColor: ColorManager.mainColor14),
          const SizedBox(width: 8),
          Expanded(child: Text(title, textAlign: TextAlign.end)),
        ],
      ),
    );
  }
}