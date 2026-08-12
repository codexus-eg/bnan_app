import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/get_monthly_certificates_cubit/get_monthly_certificates_cubit.dart';
import 'package:bnan_app/features/certificates_management/presentation/views/widgets/supervisor_classroom_dropdown.dart';
import 'package:bnan_app/features/supervisor_management/data/models/supervisor_classroom_model.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChooseClassroomCertificate extends StatefulWidget {
  const ChooseClassroomCertificate({super.key});

  @override
  State<ChooseClassroomCertificate> createState() =>
      _ChooseClassroomCertificateState();
}

class _ChooseClassroomCertificateState
    extends State<ChooseClassroomCertificate> {
  SupervisorClassroomModel? selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 16, start: 16, end: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SupervisorClassroomDropdown(
            selectedId: selected?.id,
            includeAll: true,
            backgroundColor: ColorManager.white,
            onChanged: _selectClassroom,
          ),
          const SizedBox(height: 16),
          Text(
            _title(),
            style: StylesManager.styleBold14(
              context,
            ).copyWith(color: ColorManager.mainColor15),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  void _selectClassroom(SupervisorClassroomModel? classroom) {
    setState(() => selected = classroom);
    context.read<GetMonthlyCertificatesCubit>().getMonthlyCertificates(
      classroomId: classroom?.id,
    );
  }

  String _title() =>
      '${S.of(context).certificatesWithoutArticle} '
      '${selected == null ? S.of(context).allStudents : '${S.of(context).students} ${selected!.name}'}';
}
