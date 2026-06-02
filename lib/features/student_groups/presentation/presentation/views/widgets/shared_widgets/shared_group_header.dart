import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class SharedGroupHeader extends StatelessWidget {
  const SharedGroupHeader({
    super.key,
    required this.title,
    required this.path,
    required this.badgeTitle,
    this.isIcon = false,
  });
  final String title, path, badgeTitle;
  final bool? isIcon;

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsetsDirectional.only(top: 16, end: 16),
        child: Row(
          children: [
            IconButton(
              onPressed: () => MyNavigator.pop(context),
              icon: Icon(
                isRtl ? Icons.arrow_back : Icons.arrow_forward,
                color: ColorManager.black,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              title,
              style: StylesManager.styleBold16(
                context,
              ).copyWith(color: ColorManager.black),
            ),
            const Spacer(),
            InkWell(
              onTap: () {
                MyNavigator.goToOff(context, path);
              },
              child: Container(
                padding: EdgeInsetsDirectional.only(
                  start: 8,
                  end: 8,
                  top: 5,
                  bottom: 4,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: ColorManager.mainColor14,
                ),
                child: isIcon != false
                    ? Icon(Icons.add, color: ColorManager.white)
                    : Text(badgeTitle,style: StylesManager.styleBold14(context).copyWith(
                      color: ColorManager.white
                    ),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
