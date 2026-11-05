import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/excluded_session_item.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ExcludedSessionsSheet extends StatelessWidget {
  const ExcludedSessionsSheet({super.key, required this.sessions});
  final List<ExcludedSessionItem> sessions;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.amber),
              const SizedBox(width: 8),
              Text(
                s.payrollExcludedSessionsTitle,
                style: StylesManager.styleBold16(context),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (sessions.isEmpty)
            Text(
              s.payrollExcludedSessionsReason,
              style: StylesManager.styleRegular14(context),
            )
          else
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: sessions.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (_, index) {
                  final item = sessions[index];
                  final reason = item.exclusionReason.isNotEmpty
                      ? item.exclusionReason
                      : s.payrollExcludedSessionsReason;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      item.title.isNotEmpty
                          ? item.title
                          : s.payrollSessionDetails,
                      style: StylesManager.styleMedium14(context),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (item.date.isNotEmpty)
                          Text(
                            '${item.date} ${item.time}',
                            style: StylesManager.styleRegular12(context)
                                .copyWith(color: ColorManager.grey7A7C),
                          ),
                        Text(
                          reason,
                          style: StylesManager.styleRegular12(context)
                              .copyWith(color: Colors.red[700]),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
