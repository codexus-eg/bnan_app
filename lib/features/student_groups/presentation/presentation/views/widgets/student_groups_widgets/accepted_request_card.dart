import 'package:bnan_app/core/shared_widget/custom_icon_box.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/student_groups/data/models/group_request_model.dart';
import 'package:bnan_app/features/student_groups/presentation/presentation/views/widgets/student_groups_widgets/base_group_card.dart';
import 'package:bnan_app/features/student_groups/presentation/presentation/views/widgets/student_groups_widgets/group_status_badge.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AcceptedRequestCard extends StatelessWidget {
  const AcceptedRequestCard({super.key, required this.requests});

  final List<GroupRequestModel> requests;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconBox(
                iconPath: ImageManager.celebrationOutlineIcon,
                backgroundColor: ColorManager.mainColor14,
                widgetColor: ColorManager.white,
              ),
              const SizedBox(width: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).congrats,
                    style: StylesManager.styleRegular14(
                      context,
                    ).copyWith(color: ColorManager.greyA8AF),
                  ),
                  Text(
                    S.of(context).requestAccepted,
                    style: StylesManager.styleBold16(
                      context,
                    ).copyWith(color: ColorManager.mainColor14),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 13),
          ...requests.map((item) => _RequestRow(item: item)),
        ],
      ),
    );
  }
}

class _RequestRow extends StatelessWidget {
  const _RequestRow({required this.item});

  final GroupRequestModel item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.all(8),
      margin: const EdgeInsetsDirectional.only(top: 8),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: ColorManager.black.withAlpha((255 * .25).round()),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const CustomIconBox(title: 'س'),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.teacherName,
                style: StylesManager.styleBold16(
                  context,
                ).copyWith(color: ColorManager.mainColor14),
              ),
              Row(
                children: [
                  SvgPicture.asset(ImageManager.checkIcon),
                  Text(
                    item.subtitle,
                    style: StylesManager.styleRegular14(
                      context,
                    ).copyWith(color: ColorManager.greyA8AF),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          const GroupStatusBadge(text: 'ابدأ'),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BaseGroupCard(child: child);
  }
}
