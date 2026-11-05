import 'package:bnan_app/core/shared_widget/custom_option_tile.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/student_subject_requests/data/models/subject_request_availability.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

enum AddSubjectAction { addToShared, buySinglePackage }

class AddSubjectChoiceBottomSheet extends StatelessWidget {
  const AddSubjectChoiceBottomSheet({super.key, required this.subject});
  final AvailableSubject subject;

  static Future<AddSubjectAction?> show(
    BuildContext context, {
    required AvailableSubject subject,
  }) => showModalBottomSheet<AddSubjectAction>(
    context: context,
    backgroundColor: Theme.of(context).cardColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) => AddSubjectChoiceBottomSheet(subject: subject),
  );

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(subject.name, style: StylesManager.styleBold16(context)),
        const SizedBox(height: 4),
        Text(
          S.of(context).addSubjectChoiceSubtitle,
          style: StylesManager.styleRegular12(context),
        ),
        const SizedBox(height: 16),
        CustomOptionTile(
          title: S.of(context).addToCurrentSharedPackage,
          isSelected: false,
          onTap: () => Navigator.pop(context, AddSubjectAction.addToShared),
        ),
        const SizedBox(height: 8),
        CustomOptionTile(
          title: S.of(context).buyNewSinglePackage,
          isSelected: false,
          onTap: () => Navigator.pop(context, AddSubjectAction.buySinglePackage),
        ),
      ],
    ),
  );
}
