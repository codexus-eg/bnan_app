import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/plans/presentation/models/plans_access_policy.dart';
import 'package:bnan_app/features/plans/presentation/models/plans_file_picker.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/plans_view_body.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class PlansView extends StatelessWidget {
  const PlansView({super.key, this.showEmpty = false, this.uploadFilePicker});

  final bool showEmpty;
  final PlansFilePicker? uploadFilePicker;

  @override
  Widget build(BuildContext context) {
    final policy = PlansAccessPolicy.fromRole(SessionManager.instance.userRole);
    final title = policy.isReadOnly
        ? S.of(context).dailyPlansTitle
        : S.of(context).plansTitle;
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: CustomAppbar(headerText: title),
      body: PlansViewBody(
        policy: policy,
        showEmpty: showEmpty,
        uploadFilePicker: uploadFilePicker,
      ),
    );
  }
}
