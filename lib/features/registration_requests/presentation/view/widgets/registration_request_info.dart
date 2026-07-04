import 'package:bnan_app/core/shared_widget/class_meta_row.dart';
import 'package:bnan_app/core/shared_widget/info_text.dart';
import 'package:bnan_app/features/registration_requests/data/models/registration_request_model.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class RegistrationRequestInfo extends StatelessWidget {
  const RegistrationRequestInfo({super.key, required this.requestModel});

  final RegistrationRequestModel requestModel;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClassMetaRow(
                label: '${S.of(context).curriculum}: ',
                value: requestModel.curriculum,
              ),
              ClassMetaRow(
                label: '${S.of(context).children}: ',
                value: '${requestModel.childrenCount}',
              ),
              ClassMetaRow(
                label: '${S.of(context).classes}: ',
                value: requestModel.className.join('، '),
              ),
              ClassMetaRow(
                label: '${S.of(context).subjects}: ',
                value: requestModel.subject.join('، '),
              ),
            ],
          ),
        ),
        const SizedBox(width: 30),
        Expanded(
          child: InfoText(
            label: S.of(context).registrationDate,
            value: requestModel.registrationDate,
          ),
        ),
      ],
    );
  }
}
