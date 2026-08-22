import 'package:bnan_app/core/enums/user_role.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/features/chats/data/repo/chat_repo_impl.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/support_chat_drawer_item.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('support room request sends no user id', () async {
    final api = _Api();

    await ChatRepoImpl(api).createSupportRoom();

    expect(api.path, EndPoints.createSupportRoom);
    expect(api.data, isEmpty);
    expect(api.isProtected, isTrue);
  });

  test('support chat is available to mobile roles except admin', () {
    for (final role in const [
      UserRole.student,
      UserRole.parent,
      UserRole.teacher,
      UserRole.supervisor,
    ]) {
      expect(supportsSupportChat(role), isTrue, reason: role.name);
    }
    expect(supportsSupportChat(UserRole.admin), isFalse);
    expect(supportsSupportChat(null), isFalse);
  });
}

class _Api implements ApiConsumer {
  String? path;
  Object? data;
  bool? isProtected;

  @override
  Future<dynamic> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameter,
    bool isFormData = false,
    bool isProtected = false,
  }) async {
    this.path = path;
    this.data = data;
    this.isProtected = isProtected;
    return {
      'success': true,
      'data': {'id': 'support-room', 'type': 'support'},
    };
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
