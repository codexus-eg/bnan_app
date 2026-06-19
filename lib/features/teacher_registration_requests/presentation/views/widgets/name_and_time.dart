import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/teacher_registration_requests/data/models/registration_request_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NameAndTime extends StatelessWidget {
  const NameAndTime({super.key, required this.request});

  final RegistrationRequestModel request;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(request.studentName, style: StylesManager.styleBold16(context).copyWith(
          color: ColorManager.mainColor14
        )),
        const Spacer(),
        SvgPicture.asset(
          ImageManager.clockTenIcon,
          height: 16,
          width: 16,
          colorFilter: ColorFilter.mode(ColorManager.grey7D7D, BlendMode.srcIn),
        ),
        const SizedBox(width: 4),
        Text(
          '${request.daysAgo} يوم',
          style: StylesManager.styleRegular14(
            context,
          ).copyWith(color: ColorManager.grey7D7D),
        ),
      ],
    );
  }
}
