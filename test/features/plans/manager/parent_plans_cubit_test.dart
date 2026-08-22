import 'dart:async';

import 'package:bnan_app/features/plans/data/models/elapsed_weeks_response_model.dart';
import 'package:bnan_app/features/plans/data/models/parent_children_response_model.dart';
import 'package:bnan_app/features/plans/data/models/parent_plan_child_model.dart';
import 'package:bnan_app/features/plans/data/models/plan_classroom_model.dart';
import 'package:bnan_app/features/plans/data/models/weekly_plans_response_model.dart';
import 'package:bnan_app/features/plans/presentation/manager/get_parent_plans/get_parent_plans_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_plans_repo.dart';

void main() {
  test(
    'parent uses classroom elapsed weeks and refetches selected week',
    () async {
      final repo = FakePlansRepo();
      repo.parentChildren.add(
        Completer()
          ..complete(const Right(ParentChildrenResponseModel(data: _children))),
      );
      repo.elapsed.addAll([
        Completer()..complete(const Right(_weeksResponse)),
        Completer()..complete(
          const Right(
            ElapsedWeeksResponseModel(
              data: ElapsedWeeksDataModel(weeksCount: 3, currentWeek: 2),
            ),
          ),
        ),
      ]);
      repo.weekly.addAll([
        Completer()..complete(const Right(_weekFourResponse)),
        Completer()..complete(
          const Right(
            WeeklyPlansResponseModel(data: WeeklyPlansDataModel(week: 1)),
          ),
        ),
        Completer()..complete(
          const Right(
            WeeklyPlansResponseModel(data: WeeklyPlansDataModel(week: 2)),
          ),
        ),
      ]);
      final cubit = GetParentPlansCubit(repo);

      await cubit.loadParentPlans();
      expect(cubit.availableWeeks, [1, 2, 3, 4]);
      expect(cubit.selectedWeek, 4);
      expect(repo.elapsedRequests, ['classroom-a']);
      expect(repo.weekRequests, [('classroom-a', 4)]);

      await cubit.selectWeek(1);
      expect(cubit.currentWeeklyPlan?.data.week, 1);
      expect(repo.weekRequests.last, ('classroom-a', 1));

      await cubit.selectChild('b');
      expect(cubit.availableWeeks, [1, 2, 3]);
      expect(cubit.selectedWeek, 2);
      expect(repo.elapsedRequests.last, 'classroom-b');
      expect(repo.weekRequests.last, ('classroom-b', 2));
      expect(repo.parentPlansCalls, 0);
      await cubit.close();
    },
  );
}

const _children = [
  ParentPlanChildModel(
    id: 'a',
    fullName: 'Ahmed',
    classroom: PlanClassroomModel(id: 'classroom-a', name: 'Class A'),
  ),
  ParentPlanChildModel(
    id: 'b',
    fullName: 'Mona',
    classroom: PlanClassroomModel(id: 'classroom-b', name: 'Class B'),
  ),
];

const _weeksResponse = ElapsedWeeksResponseModel(
  data: ElapsedWeeksDataModel(weeksCount: 4, currentWeek: 4),
);

const _weekFourResponse = WeeklyPlansResponseModel(
  data: WeeklyPlansDataModel(week: 4),
);
