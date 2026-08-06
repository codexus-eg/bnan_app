import 'dart:async';

import 'package:bnan_app/features/plans/data/models/parent_child_plans_model.dart';
import 'package:bnan_app/features/plans/data/models/parent_children_plans_response_model.dart';
import 'package:bnan_app/features/plans/data/models/parent_children_response_model.dart';
import 'package:bnan_app/features/plans/data/models/parent_plan_child_model.dart';
import 'package:bnan_app/features/plans/data/models/parent_plan_student_model.dart';
import 'package:bnan_app/features/plans/presentation/manager/get_parent_plans/get_parent_plans_cubit.dart';
import 'package:bnan_app/features/plans/presentation/manager/get_parent_plans/get_parent_plans_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_plans_repo.dart';

void main() {
  test('parent cubit selects first child and filters cached plans', () async {
    final repo = FakePlansRepo();
    repo.parentChildren.add(
      Completer()..complete(
        const Right(
          ParentChildrenResponseModel(
            data: [
              ParentPlanChildModel(id: 'a', fullName: 'Ahmed'),
              ParentPlanChildModel(id: 'b', fullName: 'Mona'),
            ],
          ),
        ),
      ),
    );
    repo.parentPlans.add(
      Completer()
        ..complete(Right(ParentChildrenPlansResponseModel(data: _plans))),
    );
    final cubit = GetParentPlansCubit(repo);

    await cubit.loadParentPlans();
    expect(cubit.selectedChildId, 'a');
    expect(cubit.currentPlan?.student.id, 'a');

    cubit.selectChild('b');
    expect(cubit.selectedWeek, 1);
    expect(cubit.currentPlan?.student.id, 'b');

    cubit.selectWeek(2);
    expect(cubit.currentPlan?.week, 2);
    expect(cubit.state, isA<GetParentPlansEmpty>());
    await cubit.close();
  });
}

const _plans = [
  ParentChildPlansModel(student: ParentPlanStudentModel(id: 'a'), week: 1),
  ParentChildPlansModel(student: ParentPlanStudentModel(id: 'b'), week: 1),
  ParentChildPlansModel(student: ParentPlanStudentModel(id: 'b'), week: 2),
];
