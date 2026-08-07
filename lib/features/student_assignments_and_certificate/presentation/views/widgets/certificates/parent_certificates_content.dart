import 'package:bnan_app/features/parent_home/presentation/manager/get_parent_children/get_parent_children_cubit.dart';
import 'package:bnan_app/features/parent_home/presentation/manager/get_parent_children/get_parent_children_state.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/presentation/manager/get_certificates/get_certificates_cubit.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/presentation/views/widgets/certificates/parent_certificates_children_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParentCertificatesContent extends StatefulWidget {
  const ParentCertificatesContent({super.key});

  @override
  State<ParentCertificatesContent> createState() =>
      _ParentCertificatesContentState();
}

class _ParentCertificatesContentState extends State<ParentCertificatesContent> {
  String? _requestedStudentId;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GetParentChildrenCubit, GetParentChildrenState>(
      listener: _loadSelectedCertificates,
      builder: parentCertificatesChildrenView,
    );
  }

  void _loadSelectedCertificates(
    BuildContext context,
    GetParentChildrenState state,
  ) {
    if (state is! GetParentChildrenSuccess) return;
    final id = state.selectedChildId?.trim();
    if (id == null || id.isEmpty || id == _requestedStudentId) return;
    _requestedStudentId = id;
    context.read<GetCertificatesCubit>().getMyCertificates(studentId: id);
  }
}
