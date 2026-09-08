import 'package:bnan_app/core/helper/app_pickers.dart';
import 'package:bnan_app/core/shared_widget/class_meta_row.dart';
import 'package:bnan_app/features/users_management/data/models/user_model.dart';
import 'package:bnan_app/features/users_management/presentation/widgets/user_relationship_item.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class MetaSection extends StatelessWidget {
  const MetaSection({super.key, required this.user});

  final UserItem user;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final rawDate = user.registrationDate.isNotEmpty
        ? user.registrationDate
        : user.createdAt;
    final date = AppPickers.formatDateTime(rawDate, context: context);
    final items = <UserRelationshipItem>[
      (label: s.email, value: user.email),
      (label: s.status, value: user.status),
      (label: s.registrationMode, value: user.registrationMode),
      (label: s.registrationDate, value: date),
      ...userRelationshipItems(s, user),
    ].where((item) => item.value.trim().isNotEmpty && item.value != '-');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map((item) => ClassMetaRow(label: item.label, value: item.value))
          .toList(growable: false),
    );
  }
}
