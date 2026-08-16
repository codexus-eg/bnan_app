import 'package:bnan_app/features/certificates_management/data/models/teacher_certificate_model.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/teacher_certificates_cubit/teacher_certificates_cubit.dart';
import 'package:bnan_app/features/certificates_management/presentation/views/widgets/teacher_certificate_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherCertificatesList extends StatelessWidget {
  const TeacherCertificatesList({
    super.key,
    required this.items,
    required this.loadingMore,
  });
  final List<TeacherCertificateModel> items;
  final bool loadingMore;

  @override
  Widget build(BuildContext context) => RefreshIndicator(
    onRefresh: context.read<TeacherCertificatesCubit>().load,
    child: NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.extentAfter < 200) {
          context.read<TeacherCertificatesCubit>().load(refresh: false);
        }
        return false;
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length + (loadingMore ? 1 : 0),
        itemBuilder: (_, index) => index == items.length
            ? const Center(child: CircularProgressIndicator())
            : TeacherCertificateCard(certificate: items[index]),
      ),
    ),
  );
}
