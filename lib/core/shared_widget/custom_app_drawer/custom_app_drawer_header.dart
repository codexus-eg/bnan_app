import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class CustomAppDrawerHeader extends StatelessWidget {
  const CustomAppDrawerHeader({
    super.key,
    required this.userName,
    required this.userSubtitle,
  });

  final String userName;
  final String userSubtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
         CircleAvatar(
          radius: 25,
          backgroundColor: ColorManager.beigeEDC,
          child: Text(
            'ف',
            style: StylesManager.styleBold14(context).copyWith(
              color: ColorManager.mainColor15
            )
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: StylesManager.styleBold20(context).copyWith(
                  color: ColorManager.white,
                ),
              ),
              Text(
                userSubtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: StylesManager.styleBold16(context).copyWith(
                  color: ColorManager.greyA8AF,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}