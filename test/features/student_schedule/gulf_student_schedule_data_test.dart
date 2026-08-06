import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/features/lessons_management/data/repo/gulf_schedule_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('repository uses the protected Gulf mySchedule endpoint', () async {
    final api = _Api();
    final result = await GulfScheduleRepoImpl(api).getMyGulfSchedule();

    expect(result.isRight(), isTrue);
    expect(api.path, EndPoints.myGulfSchedule);
    expect(api.isProtected, isTrue);
  });
}

class _Api implements ApiConsumer {
  String? path;
  bool? isProtected;

  @override
  Future<dynamic> get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isProtected = false,
  }) async {
    this.path = path;
    this.isProtected = isProtected;
    return {
      'success': true,
      'data': {'students': <Object>[]},
    };
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
