import 'package:bnan_app/core/enums/registration_mode.dart';
import 'package:bnan_app/features/parent_children/presentation/models/parent_add_child_args.dart';
import 'package:bnan_app/features/parent_home/data/models/parent_child_curriculum_model.dart';
import 'package:bnan_app/features/parent_home/data/models/parent_child_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('one child provides the parent curriculum context', () {
    final args = ParentAddChildArgs.fromChildren([_children.first])!;
    expect(args.curriculumId, 'egyptian-curriculum');
    expect(args.registrationMode, 'egyptian');
  });

  test('multiple matching children share one curriculum context', () {
    final args = ParentAddChildArgs.fromChildren(_matchingChildren)!;
    expect(args.curriculumId, 'egyptian-curriculum');
    expect(args.registrationMode, 'egyptian');
  });

  test('conflicting child contexts cannot start add-child', () {
    expect(ParentAddChildArgs.fromChildren(_children), isNull);
  });

  test('missing curriculum context cannot start add-child', () {
    expect(
      ParentAddChildArgs.fromChildren(const [ParentChildModel(id: 'child')]),
      isNull,
    );
  });
}

const _children = [
  ParentChildModel(
    id: 'egyptian-child',
    fullName: 'Egyptian Child',
    registrationMode: RegistrationMode.egyptian,
    curriculum: ParentChildCurriculumModel(id: 'egyptian-curriculum'),
  ),
  ParentChildModel(
    id: 'gulf-child',
    fullName: 'Saudi Child',
    registrationMode: RegistrationMode.gulf,
    curriculum: ParentChildCurriculumModel(id: 'saudi-2'),
  ),
];

const _matchingChildren = [
  ParentChildModel(
    id: 'first-child',
    registrationMode: RegistrationMode.egyptian,
    curriculum: ParentChildCurriculumModel(id: 'egyptian-curriculum'),
  ),
  ParentChildModel(
    id: 'second-child',
    registrationMode: RegistrationMode.egyptian,
    curriculum: ParentChildCurriculumModel(id: 'egyptian-curriculum'),
  ),
];
