import 'package:bnan_app/features/certificates_management/data/models/monthly_certificate_model.dart';
import 'package:bnan_app/features/certificates_management/data/models/requests/certificate_subject_request_model.dart';
import 'package:bnan_app/features/certificates_management/presentation/views/widgets/certificate_subject_row.dart';
import 'package:flutter/material.dart';

class CertificateEditSubjectsSection extends StatefulWidget {
  const CertificateEditSubjectsSection({
    super.key,
    required this.certificate,
    required this.onChanged,
  });

  final MonthlyCertificateModel? certificate;
  final ValueChanged<List<CertificateSubjectRequestModel>> onChanged;

  @override
  State<CertificateEditSubjectsSection> createState() =>
      _CertificateEditSubjectsSectionState();
}

class _CertificateEditSubjectsSectionState
    extends State<CertificateEditSubjectsSection> {
  final maxScoreControllers = <String, TextEditingController>{};
  final scoreControllers = <String, TextEditingController>{};

  bool initialized = false;

  @override
  void didUpdateWidget(
    covariant CertificateEditSubjectsSection oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.certificate != widget.certificate) {
      _initializeControllers();
    }
  }

  @override
  Widget build(BuildContext context) {
    _initializeControllers();

    final subjects = widget.certificate?.subjects ?? [];

    return Column(
      children: subjects.map((subject) {
        final id = subject.subjectId?.trim() ?? '';

        if (id.isEmpty) {
          return const SizedBox.shrink();
        }

        return CertificateSubjectRow(
          subject: subject.nameSnapshot ?? '',
          maxScoreController: maxScoreControllers[id]!,
          scoreController: scoreControllers[id]!,
        );
      }).toList(),
    );
  }

  void _initializeControllers() {
    if (initialized || widget.certificate == null) return;

    initialized = true;

    for (final subject in widget.certificate!.subjects) {
      final id = subject.subjectId?.trim() ?? '';

      if (id.isEmpty) continue;

      maxScoreControllers[id] = TextEditingController(
        text: _formatNumber(subject.maxScore),
      );

      scoreControllers[id] = TextEditingController(
        text: _formatNumber(subject.score),
      );

      maxScoreControllers[id]!.addListener(_notifyChanges);
      scoreControllers[id]!.addListener(_notifyChanges);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _notifyChanges();
    });
  }

  void _notifyChanges() {
    final subjects = maxScoreControllers.keys.map((id) {
      return CertificateSubjectRequestModel(
        subjectId: id,
        maxScore: num.tryParse(
              maxScoreControllers[id]?.text ?? '',
            ) ??
            0,
        score: num.tryParse(
              scoreControllers[id]?.text ?? '',
            ) ??
            0,
      );
    }).toList();

    widget.onChanged(subjects);
  }

  String _formatNumber(num? value) {
    if (value == null) return '';

    if (value % 1 == 0) {
      return value.toInt().toString();
    }

    return value.toString();
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