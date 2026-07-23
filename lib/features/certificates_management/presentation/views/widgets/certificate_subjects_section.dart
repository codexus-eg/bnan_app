import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/features/certificates_management/data/models/requests/certificate_subject_request_model.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/get_student_subjects_cubit/get_student_subjects_cubit.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/get_student_subjects_cubit/get_student_subjects_state.dart';
import 'package:bnan_app/features/certificates_management/presentation/views/widgets/certificate_subject_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CertificateSubjectsSection extends StatefulWidget {
  const CertificateSubjectsSection({
    super.key,
    required this.onChanged,
  });

  final ValueChanged<List<CertificateSubjectRequestModel>> onChanged;

  @override
  State<CertificateSubjectsSection> createState() =>
      _CertificateSubjectsSectionState();
}

class _CertificateSubjectsSectionState
    extends State<CertificateSubjectsSection> {
  final maxScoreControllers = <String, TextEditingController>{};
  final scoreControllers = <String, TextEditingController>{};

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetStudentSubjectsCubit, GetStudentSubjectsState>(
      builder: (context, state) {
        final isLoading = state is GetStudentSubjectsLoading;
        final subjects = state is GetStudentSubjectsSuccess
            ? state.response.data
            : [];

        _prepareControllers(subjects);

        return AppSkeletonizer(
          isLoading: isLoading,
          child: Column(
            children: subjects.map((subject) {
              final id = subject.id?.trim() ?? '';

              return CertificateSubjectRow(
                subject: subject.name ?? '',
                maxScoreController: maxScoreControllers[id]!,
                scoreController: scoreControllers[id]!,
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _prepareControllers(List<dynamic> subjects) {
    for (final subject in subjects) {
      final id = subject.id?.trim() ?? '';

      if (id.isEmpty) continue;

      maxScoreControllers.putIfAbsent(
        id,
        () => TextEditingController(text: '20'),
      );

      scoreControllers.putIfAbsent(
        id,
        TextEditingController.new,
      );

      maxScoreControllers[id]!.removeListener(_notifyChanges);
      scoreControllers[id]!.removeListener(_notifyChanges);

      maxScoreControllers[id]!.addListener(_notifyChanges);
      scoreControllers[id]!.addListener(_notifyChanges);
    }
  }

  void _notifyChanges() {
    final subjects = maxScoreControllers.keys.map((id) {
      return CertificateSubjectRequestModel(
        subjectId: id,
        maxScore: num.tryParse(maxScoreControllers[id]?.text ?? '') ?? 0,
        score: num.tryParse(scoreControllers[id]?.text ?? '') ?? 0,
      );
    }).toList();

    widget.onChanged(subjects);
  }

  @override
  void dispose() {
    for (final controller in maxScoreControllers.values) {
      controller.dispose();
    }

    for (final controller in scoreControllers.values) {
      controller.dispose();
    }

    super.dispose();
  }
}