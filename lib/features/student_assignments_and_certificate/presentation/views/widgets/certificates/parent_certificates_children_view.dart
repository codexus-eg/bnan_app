import 'package:bnan_app/features/parent_home/presentation/manager/get_parent_children/get_parent_children_cubit.dart';
import 'package:bnan_app/features/parent_home/presentation/manager/get_parent_children/get_parent_children_state.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/presentation/views/widgets/certificates/certificates_content.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/presentation/views/widgets/certificates/parent_children_certificates_filter.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/presentation/views/widgets/certificates/parent_children_certificates_terminal_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget parentCertificatesChildrenView(
  BuildContext context,
  GetParentChildrenState state,
) {
  final terminal = parentChildrenCertificatesTerminalView(context, state);
  if (terminal != null) return terminal;
  final success = state as GetParentChildrenSuccess;
  return Column(
    children: [
      ParentChildrenCertificatesFilter(
        state: success,
        onChanged: context.read<GetParentChildrenCubit>().selectChild,
      ),
      const Expanded(child: CertificatesContent(isChildCertificates: true)),
    ],
  );
}
