import 'package:bnan_app/features/plans/data/models/term_plans_response_model.dart';
import 'package:bnan_app/features/plans/presentation/models/term_plan_card_item.dart';

List<TermPlanCardItem> mapTermPlanCards(TermPlansResponseModel response) {
  final cards = <TermPlanCardItem>[];
  for (final classroom in response.items) {
    for (final subject in classroom.subjects) {
      for (var index = 0; index < subject.plans.length; index++) {
        final plan = subject.plans[index];
        cards.add(
          TermPlanCardItem(
            classroomName: classroom.classroom.name,
            subjectName: subject.name,
            attachment: plan.attachment,
            keyValue: '${classroom.classroom.id}-${subject.id}-$index',
          ),
        );
      }
    }
  }
  return cards;
}
