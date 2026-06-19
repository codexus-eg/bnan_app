import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class AddNewTopicButton extends StatelessWidget {
  const AddNewTopicButton({super.key, required this.title, this.onTap});
  final String title;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsetsDirectional.only(
          start: 25,
          end: 18,
          top: 8,
          bottom: 8,
        ),
        decoration: BoxDecoration(
          color: ColorManager.mainColor14,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add,color: ColorManager.white,),
            const SizedBox(width: 12),
            Text(
              title,
              style: StylesManager.styleBold12(
                context,
              ).copyWith(color: ColorManager.white),
            ),
          ],
        ),
      ),
    );
  }
}
