import 'package:bnan_app/features/lessons_management/presentation/manager/start_session_state.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/widgets.dart';

String? studentJoinSessionErrorMessage(
  BuildContext context,
  StartSessionState state,
) => switch ((state.eventCode ?? state.eventError)?.trim().toUpperCase()) {
  'SUBSCRIPTION_EXPIRED' => S.of(context).joinSubscriptionExpired,
  'SUBSCRIPTION_HOURS_EXHAUSTED' =>
    S.of(context).joinSubscriptionHoursExhausted,
  'SUBJECT_NOT_IN_SUBSCRIPTION' => S.of(context).joinSubjectNotInSubscription,
  _ => null,
};
