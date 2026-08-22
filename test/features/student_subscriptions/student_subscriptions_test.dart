import 'dart:async';

import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/features/student_subscriptions/data/repo/student_subscriptions_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('student subscriptions use home and subjects endpoints', () async {
    final api = _Api();
    final result = await StudentSubscriptionsRepoImpl(api).getSubscriptions();
    final student = result.getOrElse(() => throw StateError('failed'));

    expect(api.paths, [EndPoints.studentHome, EndPoints.mySubjects]);
    expect(student.registrationMode, 'egyptian');
    expect(student.subscriptions.map((item) => item.id), ['new-1', 'new-2']);
    expect(student.subscriptions.first.canRenew, isTrue);
    expect(student.subjects.single.id, 'subject-1');
  });

  test('student home and subjects requests start in parallel', () async {
    final api = _ParallelApi();
    final result = StudentSubscriptionsRepoImpl(api).getSubscriptions();
    await Future<void>.delayed(Duration.zero);

    expect(api.paths, [EndPoints.studentHome, EndPoints.mySubjects]);
    api.complete();
    expect((await result).isRight(), isTrue);
  });
}

class _ParallelApi implements ApiConsumer {
  final paths = <String>[];
  final home = Completer<Object?>();
  final subjects = Completer<Object?>();

  @override
  Future<Object?> get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isProtected = false,
  }) {
    paths.add(path);
    return path == EndPoints.studentHome ? home.future : subjects.future;
  }

  void complete() {
    home.complete({
      'data': {
        'student': {'id': 'student-1'},
        'subscriptions': <Object?>[],
      },
    });
    subjects.complete({'data': <Object?>[]});
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Api implements ApiConsumer {
  final paths = <String>[];
  @override
  Future<Object?> get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isProtected = false,
  }) async {
    paths.add(path);
    if (path == EndPoints.mySubjects) {
      return {
        'data': [
          {'id': 'subject-1', 'name': 'Math'},
        ],
      };
    }
    return {
      'data': {
        'student': {
          'id': 'student-1',
          'fullName': 'Student',
          'curriculum': {'id': 'c1', 'registrationMode': 'egyptian'},
        },
        'subscription': {'id': 'legacy'},
        'subscriptions': [
          {'id': 'new-1', 'canRenew': true},
          {'id': 'new-2'},
        ],
      },
    };
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
