import 'package:bnan_app/core/enums/registration_mode.dart';
import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/parent_children/presentation/models/parent_add_child_args.dart';
import 'package:bnan_app/features/parent_children/presentation/views/parent_add_child_route_gate.dart';
import 'package:bnan_app/features/parent_home/data/models/get_parent_children_response_model.dart';
import 'package:bnan_app/features/parent_home/data/models/parent_child_curriculum_model.dart';
import 'package:bnan_app/features/parent_home/data/models/parent_child_model.dart';
import 'package:bnan_app/features/parent_home/data/repo/parent_home_repo.dart';
import 'package:bnan_app/features/parent_home/presentation/manager/get_parent_children/get_parent_children_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('missing extra recovers first-child context', (tester) async {
    final repo = _Repo(const []);
    await tester.pumpWidget(_app(repo));
    await tester.pump();
    expect(find.text('first:false:none'), findsOneWidget);
  });

  testWidgets('missing extra recovers existing family context', (tester) async {
    final repo = _Repo(const [_child]);
    await tester.pumpWidget(_app(repo));
    await tester.pump();
    expect(find.text('existing:true:curriculum-1'), findsOneWidget);
  });

  testWidgets('valid extra starts without reloading children', (tester) async {
    final repo = _Repo(const []);
    await tester.pumpWidget(
      _app(repo, initialArgs: const ParentAddChildArgs.firstChild()),
    );
    expect(find.text('first:false:none'), findsOneWidget);
    expect(repo.calls, 0);
  });
}

Widget _app(_Repo repo, {ParentAddChildArgs? initialArgs}) {
  final cubit = GetParentChildrenCubit(repo);
  if (initialArgs == null) cubit.getParentChildren();
  return MaterialApp(
    home: BlocProvider.value(
      value: cubit,
      child: ParentAddChildRouteGate(
        initialArgs: initialArgs,
        builder: (_, args) => Text(
          '${args.parentHasChildren ? 'existing' : 'first'}:'
          '${args.parentHasChildren}:${args.curriculumId.isEmpty ? 'none' : args.curriculumId}',
        ),
      ),
    ),
  );
}

const _child = ParentChildModel(
  id: 'child-1',
  registrationMode: RegistrationMode.egyptian,
  curriculum: ParentChildCurriculumModel(id: 'curriculum-1'),
);

class _Repo implements ParentHomeRepo {
  _Repo(this.children);
  final List<ParentChildModel> children;
  int calls = 0;

  @override
  Future<Either<Failure, GetParentChildrenResponseModel>>
  getParentChildren() async {
    calls++;
    return Right(GetParentChildrenResponseModel(data: children));
  }
}
