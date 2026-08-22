import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class SubscribeButton extends StatelessWidget {
  const SubscribeButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 25,
      width:double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: ColorManager.mainColor14,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        
        child: Padding(
          padding: const EdgeInsetsDirectional.only(top:6.5,bottom: 4.5),
          child: Text(
            text,
            style: StylesManager.styleRegular12(context).copyWith(
              color: ColorManager.white,
            ),
          ),
        ),
      ),
    );
  }
}
