import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/features/certificates_management/data/models/teacher_certificate_model.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/teacher_certificates_cubit/teacher_certificates_state.dart';
import 'package:bnan_app/features/certificates_management/presentation/views/widgets/teacher_certificates_list.dart';
import 'package:flutter/material.dart';

class TeacherCertificatesContent extends StatelessWidget {
  const TeacherCertificatesContent({super.key, required this.state});
  final TeacherCertificatesState state;

  @override
  Widget build(BuildContext context) {
    if (state.status == TeacherCertificatesStatus.failure) {
      return NoDataWidget(title: state.error);
    }
    if (state.status == TeacherCertificatesStatus.success &&
        state.items.isEmpty) {
      return const NoDataWidget();
    }
    final items = state.status == TeacherCertificatesStatus.loading
        ? TeacherCertificateModel.placeholders
        : state.items;
    return AppSkeletonizer(
      isLoading: state.status == TeacherCertificatesStatus.loading,
      child: TeacherCertificatesList(
        items: items,
        loadingMore: state.loadingMore,
      ),
    );
  }
}
