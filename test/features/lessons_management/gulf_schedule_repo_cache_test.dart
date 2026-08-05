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

  @override
  Future<dynamic> get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isProtected = false,
  }) {
    getCalls++;
    return response.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
