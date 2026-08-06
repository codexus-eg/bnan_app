import 'dart:async';

import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/features/lessons_management/data/repo/gulf_schedule_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('shares one Gulf schedule request and caches its success', () async {
    final api = _GatedApi();
    final repo = GulfScheduleRepoImpl(api);

    final first = repo.getMyGulfSchedule();
    final second = repo.getMyGulfSchedule();
    expect(api.getCalls, 1);
    api.response.complete(_response);

    expect((await first).isRight(), isTrue);
    expect((await second).isRight(), isTrue);
    expect((await repo.getMyGulfSchedule()).isRight(), isTrue);
    expect(api.getCalls, 1);
  });

  test('keeps the cache separate for each selected child', () async {
    final api = _ImmediateApi();
    final repo = GulfScheduleRepoImpl(api);

    await repo.getMyGulfSchedule(studentId: 'child-1');
    await repo.getMyGulfSchedule(studentId: 'child-1');
    await repo.getMyGulfSchedule(studentId: 'child-2');

    expect(api.queries, [
      {'studentId': 'child-1'},
      {'studentId': 'child-2'},
    ]);
  });
}

const _response = {
  'success': true,
  'data': {
    'students': [
      {'classrooms': <Object>[]},
    ],
  },
};

class _GatedApi implements ApiConsumer {
  final response = Completer<Object>();
  int getCalls = 0;
  final queries = <Map<String, dynamic>?>[];

  @override
  Future<dynamic> get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isProtected = false,
  }) {
    getCalls++;
    queries.add(queryParameter);
    return response.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _ImmediateApi implements ApiConsumer {
  final queries = <Map<String, dynamic>?>[];

  @override
  Future<dynamic> get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isProtected = false,
  }) async {
    queries.add(queryParameter);
    return _response;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
