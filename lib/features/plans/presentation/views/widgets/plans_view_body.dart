import 'package:bnan_app/features/plans/presentation/policies/plans_access_policy.dart';
import 'package:bnan_app/features/plans/presentation/utils/plans_file_picker.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/plans_management_body.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/plans_parent_body.dart';
import 'package:flutter/material.dart';

class PlansViewBody extends StatelessWidget {
  const PlansViewBody({
    super.key,
    required this.policy,
    required this.showEmpty,
    this.uploadFilePicker,
  });

  final PlansAccessPolicy policy;
  final bool showEmpty;
  final PlansFilePicker? uploadFilePicker;

  @override
  Widget build(BuildContext context) {
    if (policy.showChildFilter) return PlansParentBody(policy: policy);
    return PlansManagementBody(
      policy: policy,
      showEmpty: showEmpty,
      uploadFilePicker: uploadFilePicker,
    );
  }
}
