import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class TermPlansEmpty extends StatelessWidget {
  const TermPlansEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.55,
          child: NoDataWidget(title: S.of(context).noTermPlansAvailable),
        ),
      ],
    );
  }
}
